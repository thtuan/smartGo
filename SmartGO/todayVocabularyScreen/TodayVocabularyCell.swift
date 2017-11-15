//
//  TodayVocabularyCell.swift
//  SmartGO
//
//  Created by thanh tuan on 8/7/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class TodayVocabularyCell: UICollectionViewCell {
    
    @IBOutlet weak var answerImage: UIImageView!
    
    @IBOutlet weak var lblDescribe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
    }
}
