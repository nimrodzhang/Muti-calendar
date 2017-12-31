//
//  DateCollectionViewCell.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/10.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DateBackground: UIImageView!
   // @IBOutlet weak var DateBlurEffect: UIVisualEffectView!
    @IBOutlet weak var DateView: UIView!
    
    var color = UIColor.black
    
    var year:Int?
    var month:Int?
    var weekday:Int?
    var day:Int?
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
}
