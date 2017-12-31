//
//  ThemeViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate {
  
    @IBOutlet weak var ThemeCollectionView: UICollectionView!
    
    var curImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeCollectionView.delegate = self
        ThemeCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as! ThemeCollectionViewCell
        cell.BackgroundPreview.image = curImage
        
        //粉，红，深蓝，浅蓝，绿，黄，紫，橙，黑，白
        switch indexPath.row {
        case 0:     //粉
            cell.barColor = "#E87A90"
            cell.normalColor = "#64363C"
            cell.wkdColor = "#8E354A"
            cell.todayColor = "#FBE251"
        
        case 1:     //白
            cell.barColor = "#BDC0BA"
            cell.normalColor = "#000000"
            cell.wkdColor = "#656765"
            cell.todayColor = "#FFB11B"
         
        case 2:     //黑
            cell.barColor = "#000000"
            cell.normalColor = "#BDC0BA"
            cell.wkdColor = "#656765"
            cell.todayColor = "#FFB11B"
        
        case 3:     //黄
            cell.barColor = "#F9BF45"
            cell.normalColor = "#563F2E"
            cell.wkdColor = "#8F5A3C"
            cell.todayColor = "#24936E"
            
        case 4:     //绿
            cell.barColor = "#86C166"
            cell.normalColor = "#3C2F41"
            cell.wkdColor = "#5E3D50"
            cell.todayColor = "#CB1B45"
        
        case 5:     //淡紫
            cell.barColor = "#B481BB"
            cell.normalColor = "#3F2B36"
            cell.wkdColor = "#005CAF"
            cell.todayColor = "#F75C2F"
            
        case 6:     //蓝
            cell.barColor = "#2EA9DF"
            cell.normalColor = "#0D5661"
            cell.wkdColor = "#005CAF"
            cell.todayColor = "#FC9F4D"
        
        case 7:     //橙
            cell.barColor = "#ED784A"
            cell.normalColor = "#211E55"
            cell.wkdColor = "#787878"
            cell.todayColor = "#58B2DC"
            
            
        default:
            exit(0)
        }
        
        cell.TitleLabel.backgroundColor = UIColor.colorWithHexString(hex: cell.barColor!)
        cell.TitleLabel.textColor = UIColor.colorWithHexString(hex: cell.normalColor!)
        cell.NormalLabel.textColor = UIColor.colorWithHexString(hex: cell.normalColor!)
        cell.WkdLabel.textColor = UIColor.colorWithHexString(hex: cell.wkdColor!)
        cell.TodayLabel.textColor = UIColor.colorWithHexString(hex: cell.todayColor!)
        cell.MenuLabel.backgroundColor = UIColor.colorWithHexString(hex: cell.barColor!)
        cell.MenuLabel.textColor = UIColor.colorWithHexString(hex: cell.wkdColor!)

        return cell
    }
    

    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let des = segue.destination as! CalendarViewController
        let cell = sender as! ThemeCollectionViewCell
        
        des.barColorString = cell.barColor!
        des.normalColorString = cell.normalColor!
        des.wkdColorString = cell.wkdColor!
        des.todayColorString = cell.todayColor!
        
        
    }
    

}
