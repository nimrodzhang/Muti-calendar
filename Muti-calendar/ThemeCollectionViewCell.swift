//
//  ThemeCollectionViewCell.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var BackgroundPreview: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var MenuLabel: UILabel!
    @IBOutlet weak var NormalLabel: UILabel!
    @IBOutlet weak var WkdLabel: UILabel!
    @IBOutlet weak var TodayLabel: UILabel!
    
    var barColor: String?
    var normalColor: String?
    var wkdColor: String?
    var todayColor: String?
    
}
