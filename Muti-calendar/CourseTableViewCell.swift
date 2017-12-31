//
//  CourseTableViewCell.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var beginTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Location: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
