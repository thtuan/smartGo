//
//  LevelController.swift
//  SmartGO
//
//  Created by thanh tuan on 8/11/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class LevelController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier!{
        case "basic":
            let vc = segue.destination as! LessonController
            vc.linkAudio = "/learn/basic/lesson/1/listen/audio"
        case "intermediate":
            let vc = segue.destination as! LessonController
            vc.linkAudio = "/learn/basic/lesson/1/listen/intermediateAudio"
        default:
            break
        }
    }
    

}
