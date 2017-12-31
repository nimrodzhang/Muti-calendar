//
//  DocumentTableViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import CoreData

class DocumentTableViewController: UITableViewController {

    var documents:Array<Document>?
    var curCourseName = " "
    
    var barColorString: String!
    var normalColorString: String!
    
    @IBOutlet weak var editDocs: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editDocs = editButtonItem
        
        //从数据库加载文件信息
        loadDocuments()
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
        return documents!.count
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
            let seek:Document = self.documents![indexPath.row]
            
            //删除文件
            let fileManager = FileManager.default
            let isFilePath = seek.docPath!
            do {
                try fileManager.removeItem(atPath: isFilePath)
            }catch{
                print("delete file fail")
                //删除失败，警告提示
                let alert = UIAlertController(title: "文件不存在", message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
            }
            
            
            //从数据库中删除信息
            let appDel = UIApplication.shared.delegate as! AppDelegate
            let container = appDel.persistentContainer
            let context = container.viewContext
            let fetch: NSFetchRequest<Document> = Document.fetchRequest()
            fetch.predicate = NSPredicate(format: "self == %@", seek)
            do {
                let rsts = try context.fetch(fetch)
                for doc in rsts {
                    context.delete(doc)
                }
            }catch {
                print("seek error at doc table")
            }
            do {
                try context.save()
            }catch {
                print("context can't save! at doc table")
            }
            
            self.documents?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as! DocumentTableViewCell

        // Configure the cell...
        let doc = documents![indexPath.row]
        cell.DocName.text = doc.docName
        cell.DocPath.text = doc.docPath
        cell.DocType = doc.docType
        let typename = doc.docType ?? ""
        
        //根据不同文件类型显示不同的类型提示图
        switch (typename) {
        case "doc","docx":
            print("word")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "word")
            
        case "ppt","pptx":
            print("ppt")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "ppt")
            
        case "xls","xlsx":
            print("excel")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "excel")
            
        case "pdf":
            print("pdf")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "pdf")
            
        case "txt":
            print("txt")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "txt")
            
        case "htm","html":
            print("web")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "web")
            
        case "zip","rar","tar","gz","bz2":
            print("compress")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "compress")
            
        case "avi","mpeg","mpg","rmvb","mkv","flv","mp4":
            print("video")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "video")
            
        case "mp3","wav","flac":
            print("audio")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "audio")
            
        case "bmp","jpg","jpeg","png":
            print("picture")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "picture")
            
        case "bt":
            print("bt")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "bt")
            
        default:
            print("unknown")
            cell.DocTypeImage.image = #imageLiteral(resourceName: "unknown")
            
        }
        
        return cell
    }
    
    
    //从数据库加载文件信息
    private func loadDocuments() {
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        let fetch: NSFetchRequest<Document> = Document.fetchRequest()
        fetch.predicate = NSPredicate(format: "courseName == %@", curCourseName)
        do {
            documents = try context.fetch(fetch)
        }catch {
            print("load error at doc table")
        }
    }
    
    //从子界面返回
    @IBAction func unwindToDocumentList (sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewDocumentViewController {
            
            loadDocuments()
            tableView.reloadData()
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
            
        //去新添加文件的界面
        case "NewDocument":
            let newDocumentView = segue.destination as! NewDocumentViewController
            newDocumentView.curCourseName = curCourseName
            newDocumentView.barColorString = self.barColorString
            newDocumentView.normalColorString = self.normalColorString
            
        //去读已有文件的界面
        case "ReadDocument":
            let readDocumentView = segue.destination as! ReadDocumentViewController
            let selectCell = sender as! DocumentTableViewCell
            readDocumentView.docName = selectCell.DocName.text
            readDocumentView.docPath = selectCell.DocPath.text
            readDocumentView.docType = selectCell.DocType!
        default:
            print("Error:preparefuncinDocumentTableViewController!!!")
        }
    }
    

}
