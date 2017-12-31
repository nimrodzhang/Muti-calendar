//
//  CalendarViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit


class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,  UINavigationControllerDelegate, UIToolbarDelegate{
    

    @IBOutlet weak var DateCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    //Date Title
    @IBOutlet weak var yearPos1: UIImageView!
    @IBOutlet weak var yearPos2: UIImageView!
    @IBOutlet weak var yearPos3: UIImageView!
    @IBOutlet weak var yearPos4: UIImageView!
    @IBOutlet weak var yearCharacter: UIImageView!
    @IBOutlet weak var monthPos1: UIImageView!
    @IBOutlet weak var monthPos2: UIImageView!
    @IBOutlet weak var monthCharacter: UIImageView!
    
    //weekday title
    @IBOutlet weak var weekday7: UIImageView!
    @IBOutlet weak var weekday1: UIImageView!
    @IBOutlet weak var weekday2: UIImageView!
    @IBOutlet weak var weekday3: UIImageView!
    @IBOutlet weak var weekday4: UIImageView!
    @IBOutlet weak var weekday5: UIImageView!
    @IBOutlet weak var weekday6: UIImageView!
    
    
    //Tool bar
    @IBOutlet weak var ToolBar: UIToolbar!
    
    var today = DateComponents()
    var baseday = DateComponents() //用来计算月份的某天
    
    //Theme Color
    var barColorString: String = "#BDC0BA"
    var normalColorString: String = "#000000"
    var wkdColorString: String = "#656765"
    var todayColorString: String = "#FFB11B"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ToolBar.delegate = self
        
        // Do any additional setup after loading the view.
        DateCollectionView.delegate = self
        DateCollectionView.dataSource = self
        
        self.view.sendSubview(toBack: backgroundImage)
        
        //配置collectionview的布局
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: DateCollectionView.frame.width/7, height: DateCollectionView.frame.height/6)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        DateCollectionView.collectionViewLayout = layout
        DateCollectionView.isPagingEnabled = true
        
        today = Calendar.current.dateComponents([.year, .month, .weekday, .day], from: Date())
        baseday = today
        
        
        /*
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame
        backgroundImage.addSubview(blurView)
        */
        
        loadUserDefaults()
        reloadTheme()
        
    }
    
    func loadUserDefaults() {
        let ud = UserDefaults.standard
        
        if let tbgdata = ud.data(forKey: "backgroundimage") {
            backgroundImage.image = UIImage(data: tbgdata)
        }
        if let barsting = ud.string(forKey: "barcolor") {
            barColorString = barsting
        }
        if let normalstring = ud.string(forKey: "normalcolor") {
            normalColorString = normalstring
        }
        if let wkdstring = ud.string(forKey: "wkdcolor") {
            wkdColorString = wkdstring
        }
        if let todaystring = ud.string(forKey: "todaycolor") {
            todayColorString = todaystring
        }
    
    }
    
    func reloadTheme() {
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithHexString(hex: barColorString)
        self.navigationController?.navigationBar.tintColor = UIColor.colorWithHexString(hex: normalColorString)
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.colorWithHexString(hex: normalColorString)]
        ToolBar.barTintColor = UIColor.colorWithHexString(hex: barColorString)
        ToolBar.tintColor = UIColor.colorWithHexString(hex: wkdColorString)
        
        setDateTitle()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
        
        //启用cell
        cell.isUserInteractionEnabled = true
        
        /*
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(recognizer:)))
        
        cell.addGestureRecognizer(gestureRecognizer)
        */
        
        
        let daysinCurMonth = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: baseday)!)
        
        var firstWeekDay = (baseday.weekday! - baseday.day!) % 7
        if firstWeekDay < 0 {
            firstWeekDay += 7
        }
        
        
        var day:Int = 0
        let i = indexPath.row
        
        if i<firstWeekDay {
            //print("i<fwd:\(i)-\(firstWeekDay)")
            cell.backgroundColor = UIColor.clear
            cell.DateBackground.image = nil
            cell.DateLabel.text = ""
            //禁用cell
            cell.isUserInteractionEnabled = false
            
        }else if i>firstWeekDay+(daysinCurMonth?.count)!-1 {
            cell.backgroundColor = UIColor.clear
            cell.DateBackground.image = nil
            cell.DateLabel.text = ""
            //禁用cell
            cell.isUserInteractionEnabled = false
            
        }else {
            day = i-firstWeekDay+1
            
            //在这里对应颜色
            let color = UIColor.colorWithHexString(hex: normalColorString)
                cell.DateBackground.image = UIImage(named: "day\(day)")?.tintColor(color: color, blendMode: .destinationIn)
            
            cell.backgroundColor = UIColor.clear
            cell.DateBackground.backgroundColor = UIColor.clear
            cell.DateLabel.text = ""
            
            cell.year = baseday.year
            cell.month = baseday.month
            cell.day = day
            cell.weekday = i%7
        }
        
   
        if i%7 == 0 || i%7 == 6 {
            let color = UIColor.colorWithHexString(hex: wkdColorString)
            cell.DateBackground.image = UIImage(named: "day\(day)")?.tintColor(color: color, blendMode: .destinationIn)
        }

        
        if day == today.day && baseday.month == today.month && baseday.year == today.year {
            
            /*BLUR VIEW
            let darkEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: darkEffect)
            blurView.frame = cell.DateView.frame
            cell.DateBackground.addSubview(blurView)
            //cell.DateBackground.sendSubview(toBack: blurView)
            //cell.DateView.addSubview(blurView)
            //cell.DateView.sendSubview(toBack: blurView)
            */
            
            let color = UIColor.colorWithHexString(hex: todayColorString)
            cell.DateBackground.image = UIImage(named: "day\(day)")?.tintColor(color: color, blendMode: .destinationIn)
      
        }
        

        let month = baseday.month
        if month == 1 && day == 1 {
            cell.DateLabel.text = "元旦"
        }
        if month == 3 && day == 8 {
            cell.DateLabel.text = "妇女节"
        }
        if month == 5 && day == 1 {
            cell.DateLabel.text = "劳动节"
        }
        if month == 6 && day == 1 {
            cell.DateLabel.text = "儿童节"
        }
        if month == 8 && day == 1 {
            cell.DateLabel.text = "建军节"
        }
        if month == 10 && day == 1 {
            cell.DateLabel.text = "国庆节"
        }
        if month == 12 && day == 25 {
            cell.DateLabel.text = "圣诞节"
        }
        cell.DateLabel.textColor = UIColor.colorWithHexString(hex: todayColorString)
        
        return cell
    }

    
    @objc func cellLongPress(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began {
            let location = recognizer.location(in: self.DateCollectionView)
            let indexPath = self.DateCollectionView.indexPathForItem(at: location)
            let cell = self.DateCollectionView.cellForItem(at: indexPath!) as! DateCollectionViewCell
            let day = cell.day!
            
            if cell.color == UIColor.black {
                cell.DateBackground.image = UIImage(named: "day\(day)")?.tintColor(color: UIColor.white, blendMode: .destinationIn)
                cell.color = UIColor.white
            }else {
                cell.DateBackground.image = UIImage(named: "day\(day)")?.tintColor(color: UIColor.black, blendMode: .destinationIn)
                cell.color = UIColor.black
            }
   
        }
    }
    
    
    
    
    
    @IBAction func returnToday(_ sender: UIBarButtonItem) {
        //DateTitle.text = "2017.12"
        UIView.transition(with: self.DateCollectionView, duration: 0.5, options: .transitionFlipFromBottom, animations: {()->Void in
            
            self.baseday = self.today
 
        }
            ,completion: nil)
        
        
        setDateTitle()
        self.DateCollectionView.reloadData()
    }
    

    @IBAction func swipetoNextMonth(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(with: self.DateCollectionView, duration: 0.5, options: .transitionFlipFromRight, animations: {()->Void in
            
            let day = 1
            let daysinCurMonth = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: self.baseday)!)?.count
            var firstWeekDay = (self.baseday.weekday! - self.baseday.day!) % 7
            if firstWeekDay < 0 {
                firstWeekDay += 7
            }
            let wd = (daysinCurMonth! + firstWeekDay + 1)%7
            let month = self.baseday.month!%12 + 1
            let year = self.baseday.year! + self.baseday.month!/12
            
            self.baseday.setValue(day, for: .day)
            self.baseday.setValue(wd, for: .weekday)
            self.baseday.setValue(month, for: .month)
            self.baseday.setValue(year, for: .year)
            
        }
            ,completion: nil)
        
        setDateTitle()
        self.DateCollectionView.reloadData()
        
    }
    
    
    @IBAction func swipetoPreviousMonth(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(with: self.DateCollectionView, duration: 0.5, options: .transitionFlipFromLeft, animations: {()->Void in
            
            let day = 1
            var month = (self.baseday.month! - 1)%12
            var year = self.baseday.year!
            if month <= 0 {
                month += 12
                year -= 1
            }
            var firstWeekDay = (self.baseday.weekday! - self.baseday.day!) % 7
            if firstWeekDay < 0 {
                firstWeekDay += 7
            }
            
            self.baseday.setValue(day, for: .day)
            self.baseday.setValue(month, for: .month)
            self.baseday.setValue(year, for: .year)
            
            let daysinPreMonth = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: self.baseday)!)?.count
            
            let wd = (firstWeekDay - daysinPreMonth! + 1)%7 + 7
            self.baseday.setValue(wd, for: .weekday)
            
        }
            ,completion: nil)
        
        
        setDateTitle()
        self.DateCollectionView.reloadData()
        
    }
    

    
    
    //设置大标题
    private func setDateTitle() {
        let year = baseday.year!
        let month = baseday.month!
        
        let yearpos1 = year / 1000
        let yearpos2 = (year - 1000*yearpos1) / 100
        let yearpos3 = (year - 1000*yearpos1 - 100*yearpos2) / 10
        let yearpos4 = year % 10
        let monthpos1 = month / 10
        let monthpos2 = month % 10
       
        print(yearpos1)
        print(yearpos2)
        print(yearpos3,yearpos4,monthpos1,monthpos2)
        
        
        let color = UIColor.colorWithHexString(hex: normalColorString)
        let backup = UIColor.colorWithHexString(hex: wkdColorString)
    
        yearPos1.image = UIImage(named: "num\(yearpos1)")?.tintColor(color: color, blendMode: .destinationIn)
        yearPos2.image = UIImage(named: "num\(yearpos2)")?.tintColor(color: color, blendMode: .destinationIn)
        yearPos3.image = UIImage(named: "num\(yearpos3)")?.tintColor(color: color, blendMode: .destinationIn)
        yearPos4.image = UIImage(named: "num\(yearpos4)")?.tintColor(color: color, blendMode: .destinationIn)
        yearCharacter.image = #imageLiteral(resourceName: "charY").tintColor(color: color, blendMode: .destinationIn)
        monthPos1.image = UIImage(named: "num\(monthpos1)")?.tintColor(color: color, blendMode: .destinationIn)
        monthPos2.image = UIImage(named: "num\(monthpos2)")?.tintColor(color: color, blendMode: .destinationIn)
        monthCharacter.image = #imageLiteral(resourceName: "charM").tintColor(color: color, blendMode: .destinationIn)
            
        weekday1.image = #imageLiteral(resourceName: "monday").tintColor(color: color, blendMode: .destinationIn)
        weekday2.image = #imageLiteral(resourceName: "tuesday").tintColor(color: color, blendMode: .destinationIn)
        weekday3.image = #imageLiteral(resourceName: "wednesday").tintColor(color: color, blendMode: .destinationIn)
        weekday4.image = #imageLiteral(resourceName: "thursday").tintColor(color: color, blendMode: .destinationIn)
        weekday5.image = #imageLiteral(resourceName: "friday").tintColor(color: color, blendMode: .destinationIn)
        weekday6.image = #imageLiteral(resourceName: "saturday").tintColor(color: backup, blendMode: .destinationIn)
        weekday7.image = #imageLiteral(resourceName: "sunday").tintColor(color: backup, blendMode: .destinationIn)
        
    }
    
    
    //MARK: - 禁止掉更换图标时的Alert
    
    func runtimeRemoveAlert() -> Void {
        if let presentM = class_getInstanceMethod(type(of: self), #selector(present(_:animated:completion:))),
            let presentSwizzlingM = class_getInstanceMethod(type(of: self), #selector(temporary_present(_:animated:completion:))){
            method_exchangeImplementations(presentM, presentSwizzlingM)
        }
    }
    //利用runtime恢复方法实现
    func runtimeResetAlert() -> Void {
        if let presentM = class_getInstanceMethod(type(of: self), #selector(present(_:animated:completion:))),
            let presentSwizzlingM = class_getInstanceMethod(type(of: self), #selector(temporary_present(_:animated:completion:))){
            method_exchangeImplementations(presentM, presentSwizzlingM)
        }
    }
    
    //在自己实现中特殊处理
    @objc dynamic func temporary_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil){
        if viewControllerToPresent.isKind(of: UIAlertController.self) {
            if let alertController = viewControllerToPresent as? UIAlertController{
                //通过判断title和message都为nil，得知是替换icon触发的提示。
                if alertController.title == nil && alertController.message == nil {
                    return;
                }
            }
        }
        
        self.temporary_present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.runtimeRemoveAlert()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.runtimeResetAlert()
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "CourseTableView":
            let courseTableView = segue.destination as! CourseTableViewController
            let selectCell = sender as! DateCollectionViewCell
            var xday = DateComponents()
            xday.year = selectCell.year
            xday.month = selectCell.month
            xday.weekday = selectCell.weekday
            xday.day = selectCell.day
            
            //setvalueofcalday
            courseTableView.calday = xday
            courseTableView.barColorString = self.barColorString
            courseTableView.normalColorString = self.normalColorString
            courseTableView.wkdColorString = self.wkdColorString
            //courseTableView.backgroundImage = self.backgroundImage.image
            
        case "ChangeBackgroundImage":
            //let BackgroundCollectionView = segue.destination as! BackgroundCollectionViewController
            print("enter change BG")
            
        case "ChangeTheme":
            let ThemeCollectionView = segue.destination as! ThemeViewController
            ThemeCollectionView.curImage = backgroundImage.image
            print("enter change theme")
            
        default:
            print("Error:preparefuncinCalendarViewController!!!")
        }
    }
    
    
    @IBAction func unwindfromBackgroundView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BackgroundViewController {
            let imagereturned = sourceViewController.ChosenImage
            backgroundImage.image = imagereturned
            let imagedata = UIImagePNGRepresentation(imagereturned!)
            
            UserDefaults.standard.set(imagedata, forKey: "backgroundimage")
            
        }else {
            print("error at unwind in calendar view")
        }
    }

    @IBAction func unwindfromThemeView(sender: UIStoryboardSegue) {
        if sender.source is ThemeViewController {
            
            UserDefaults.standard.set(barColorString, forKey: "barcolor")
            UserDefaults.standard.set(normalColorString, forKey: "normalcolor")
            UserDefaults.standard.set(wkdColorString, forKey: "wkdcolor")
            UserDefaults.standard.set(todayColorString, forKey: "todaycolor")
        }
        DateCollectionView.reloadData()
        reloadTheme()
    }
    
}




