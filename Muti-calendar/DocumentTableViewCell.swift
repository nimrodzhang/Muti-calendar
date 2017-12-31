//
//  DocumentTableViewCell.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var DocName: UILabel!
    @IBOutlet weak var DocPath: UILabel!
    @IBOutlet weak var DocTypeImage: UIImageView!
    var DocType:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
