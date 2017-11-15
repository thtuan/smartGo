//
//  NetworkManager.swift
//  SmartGO
//
//  Created by thanh tuan on 7/12/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func downloadFileFromURL(url:URL) {
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
            
        })
        downloadTask.resume()
    }
}

