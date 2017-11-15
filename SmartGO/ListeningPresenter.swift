//
//  ListenningPresenter.swift
//  SmartGO
//
//  Created by thanh tuan on 7/12/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol ListenningPresenterInput {
    func downloadFileFromURL(url:URL)
}
class ListenningPresenter: ListenningPresenterInput {
    
    var view:ListenningControllerInput!
    func downloadFileFromURL(url:URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
            if error == nil{
                self.view.setAudio(url: url)
            }else{
                self.view.showError(message: (error?.localizedDescription)!)
            }
        })
        
        downloadTask.resume()
        
    }
}
