//
//  OutstandingLessonCell.swift
//  SmartGO
//
//  Created by thanh tuan on 8/9/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class OutstandingLessonCell: UITableViewCell {

    
    @IBOutlet weak var imageOutstanding: UIImageView!
    
    @IBOutlet weak var lblNameOutstanding: UILabel!
    
    @IBOutlet weak var lblDescribe: UILabel!
    
    @IBOutlet weak var btnInfor: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
