//
//  InformationPopoverController.swift
//  SmartGO
//
//  Created by thanh tuan on 8/18/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class InformationPopoverController: UIViewController {
    
    var infor: String?
    
    @IBOutlet var lblInformation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let information = infor{
            lblInformation.text = information
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
