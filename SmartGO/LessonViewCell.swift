//
//  LessonViewCell.swift
//  SmartGO
//
//  Created by thanh tuan on 7/14/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class LessonViewCell: UITableViewCell {
    
    @IBOutlet weak var lblLesson: UILabel!
    @IBOutlet weak var imgLesson: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var contentViewCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        contentViewCell.layer.cornerRadius = 10
        contentViewCell.backgroundColor = UIColor.white
        contentViewCell.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
