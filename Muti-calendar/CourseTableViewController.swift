//
//  CourseTableViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import CoreData

class CourseTableViewController: UITableViewController {

    var courses: Array<Course>?
    var calday = DateComponents()
    //var curCourseName: String?
    
    @IBOutlet weak var courseTitle: UINavigationItem!
    
    //var backgroundImage: UIImage?
    var barColorString: String!
    var normalColorString: String!
    var wkdColorString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        backgroundImage.frame = self.view.frame
        self.view.addSubview(backgroundImage)
        self.view.sendSubview(toBack: backgroundImage)
        */
        loadCourses()
        
        /*
        if let imagedata = UserDefaults.standard.data(forKey: "backgroundimage"){
             backgroundImage = UIImage(data: imagedata)
            print("ok")
        }
        */
        
        switch (calday.weekday!) {
        case 0:
            courseTitle.title = "周日"
        case 1:
            courseTitle.title = "周一"
        case 2:
            courseTitle.title = "周二"
        case 3:
            courseTitle.title = "周三"
        case 4:
            courseTitle.title = "周四"
        case 5:
            courseTitle.title = "周五"
        case 6:
            courseTitle.title = "周六"
        default:
            courseTitle.title = "不知道周几"
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses!.count
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
        
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let seek:Course = self.courses![indexPath.row]
            
            if seek.isOnlyToday == true {
                let alert = UIAlertController(title: "确定删除？", message: "该课程的所有文档都会被删除", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                    self.deleteThisCourse(seek: seek)
                    self.courses?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                })
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
               
            }
            else {
                let alert = UIAlertController(title: "确定删除？", message: "这将会删除每周这一天的该课程及其文档", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                    self.deleteThisCourse(seek: seek)
                    self.courses?.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                })
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    private func deleteThisCourse(seek: Course) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        
        //从数据库删除所有文档
        let docFetch: NSFetchRequest<Document> = Document.fetchRequest()
        docFetch.predicate = NSPredicate(format: "courseName == %@", seek.name!)
        do {
            let docRsts = try context.fetch(docFetch)
            for doc in docRsts {
                context.delete(doc)
            }
        }catch {
            print("seek error at course table")
        }
        do {
            try context.save()
        }catch {
            print("context can't save! at course table")
        }
        
        
        //从数据库中删除信息
        let fetch: NSFetchRequest<Course> = Course.fetchRequest()
        fetch.predicate = NSPredicate(format: "self == %@", seek)
        do {
            let crsRsts = try context.fetch(fetch)
            for crs in crsRsts {
                context.delete(crs)
            }
        }catch {
            print("seek error at course table")
        }
        do {
            try context.save()
        }catch {
            print("context can't save! at course table")
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell", for: indexPath) as! CourseTableViewCell

        // Configure the cell...

        /*
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.lightGray
        }
        */
        
        let course = courses![indexPath.row]
        cell.beginTime.text = "\(course.starthour):\(course.startminute)"
        cell.endTime.text = "\(course.endhour):\(course.endminute)"
        cell.Name.text = course.name
        cell.Location.text = course.location
        
        return cell
    }
    
    //Actions
    @IBAction func unwindToCourseList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewCourseManuallyViewController {
            /*print("tempcscount:\(tempcs.count)")
            for i in 0..<tempcs.count {
                let newIndexPath = IndexPath(row:courses.count, section:0)
                courses.append(tempcs[i])
                tableView.insertRows(at: [newIndexPath], with: .automatic)
 */
            loadCourses()
            tableView.reloadData()
        }
        else {
            print("???")
        }
        
    }
    
    private func saveCourses() {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        do {
            try container.viewContext.save()
            print("savesuccess")
        }catch let error {
            print("context can't save:\(error)")
        }
    }
    
    private func loadCourses() {
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        let fetch: NSFetchRequest<Course> = Course.fetchRequest()
        let curWeekday = calday.weekday!
        fetch.predicate = NSPredicate(format: "weekday == %@", NSNumber(value: curWeekday))
        do {
            courses = try context.fetch(fetch)
            
        }catch let error {
            print("load error:\(error)")
        }
        
        for i in 0..<courses!.count {
            if courses![i].isOnlyToday == true {
                if courses![i].year != Int32(calday.year!) || courses![i].month != Int32(calday.month!) || courses![i].day != Int32(calday.day!) {
                    courses!.remove(at: i)
                }
            }
        }
        
        courses = courses?.sorted(by: { (c1, c2) -> Bool in
            if c1.starthour < c2.starthour {
                return true
            }
            else if c1.starthour == c2.starthour && c1.startminute < c2.startminute {
                return true
            }
            else {
                return false
            }
        })
        
    }
 /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("lalala!!!\(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath) as! CourseTableViewCell
        curCourseName = cell.Name.text
        print(cell.Name.text!)
        
    }
*/
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "NewCourseManually":
            let newCourseManuallyView = segue.destination as! NewCourseManuallyViewController
            newCourseManuallyView.calday = calday
            //newCourseManuallyView.barColorString = self.barColorString
            //newCourseManuallyView.normalColorString = self.normalColorString
            //newCourseManuallyView.wkdColorString = self.wkdColorString
            //newCourseManuallyView.backgroundImageView.image = self.backgroundImage
            
            //print("newcourse")
        case "DocumentTableView":
            let docTableView = segue.destination as! DocumentTableViewController
            let selectCell = sender as! CourseTableViewCell
        
            //print("enter doc")
            docTableView.curCourseName = selectCell.Name.text!
            docTableView.barColorString = self.barColorString
            docTableView.normalColorString = self.normalColorString
            
        default:
            print("Error:preparefuncinCourseTableViewController!!!")
        }
    }
    

}
