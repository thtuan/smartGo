//
//  CheckSpeakViewCell.swift
//  SmartGO
//
//  Created by thanh tuan on 8/2/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol ActionCellProtocol {
    func pressButton(sender: UIButton)
}

class CheckSpeakViewCell: UITableViewCell {
    var actionCell: ActionCellProtocol?
    
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnSpeak: UIButton!
    
    @IBAction func clickToSpeak(_ sender: UIButton) {
        actionCell?.pressButton(sender: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellContent.layer.cornerRadius = 10
        self.cellContent.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
