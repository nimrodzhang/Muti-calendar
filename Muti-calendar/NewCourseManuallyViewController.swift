//
//  NewCourseManuallyViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import CoreData

class NewCourseManuallyViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var starttimePicker: UIDatePicker!
    @IBOutlet weak var endtimePicker: UIDatePicker!
    @IBOutlet weak var applytoweekSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var getNameLabel: UILabel!
    @IBOutlet weak var getLocationLabel: UILabel!
    @IBOutlet weak var getStartLabel: UILabel!
    @IBOutlet weak var getEndLabel: UILabel!
    @IBOutlet weak var applytoweekLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var barColorString: String!
    var normalColorString: String!
    var wkdColorString: String!
    
    //var courses: Array<Course>?
    var calday = DateComponents()
    //var tempstr:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let imagedata = UserDefaults.standard.data(forKey: "backgroundimage"){
            backgroundImageView.image = UIImage(data: imagedata)
            print("ok")
        }
        if let barsting = UserDefaults.standard.string(forKey: "barcolor") {
            barColorString = barsting
        }
        if let normalstring = UserDefaults.standard.string(forKey: "normalcolor") {
            normalColorString = normalstring
        }
       
        nameTextField.delegate = self
        locationTextField.delegate = self
        
        let textcolor = UIColor.colorWithHexString(hex: normalColorString)
        
        getNameLabel.textColor = textcolor
        getLocationLabel.textColor = textcolor
        getStartLabel.textColor = textcolor
        getEndLabel.textColor = textcolor
        applytoweekLabel.textColor = textcolor
        starttimePicker.tintColor = textcolor
        endtimePicker.tintColor = textcolor
        
        
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateSaveButtonState() {
        let text1 = nameTextField.text ?? ""
        saveButton.isEnabled = !text1.isEmpty
    }
    
    //MARK: uitextfielddelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    
    
    
    // MARK: - Navigation

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        let isPresentingInAddCourseMode = presentingViewController is UINavigationController
        
        if isPresentingInAddCourseMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The NewCourseManuallyViewController is not inside a navigation controller.")
        }
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        let button = sender as? UIBarButtonItem
        if button != saveButton {
            print("button!=save")
        }
        
        let startdate = starttimePicker.date
        let enddate = endtimePicker.date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let startstr = dateformatter.string(from: startdate)
        let endstr = dateformatter.string(from: enddate)
        let startArray = startstr.components(separatedBy: ":")
        let endArray = endstr.components(separatedBy: ":")
        
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: context) as! Course
        course.name = nameTextField.text
        course.location = locationTextField.text
        course.starthour = Int32(startArray[0])!
        course.endhour = Int32(endArray[0])!
        course.startminute = Int32(startArray[1])!
        course.endminute = Int32(endArray[1])!
        course.isOnlyToday = !applytoweekSwitch.isOn
        
        course.year = Int32(calday.year!)
        course.month = Int32(calday.month!)
        course.weekday = Int32(calday.weekday!)
        course.day = Int32(calday.day!)
        
        do {
            try context.save()
        }catch {
            print("save error at newcoursemanually")
        }
        
    }
    

}
