//
//  ListenningPresenter.swift
//  SmartGO
//
//  Created by thanh tuan on 7/12/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol ListeningPresenterInput {
    func downloadAudioFromURL(url:URL, filename: String, ext: String)
    func downloadSubFromURL(url:URL, filename: String, ext: String)
    func loadRunningSubFromURL(url: URL, filename: String, ext: String)
}
class ListeningPresenter: ListeningPresenterInput {
    
    var view:ListeningControllerInput!
    var interactor: ListeningInteractorInput!
    
    func downloadAudioFromURL(url:URL, filename: String, ext: String ){
        let file = FileManager()
        let newURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename + ext)
        if !file.fileExists(atPath: newURL.path){
            let downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
                if error == nil{
                    do {
                        try file.copyItem(at: URL!, to: newURL)
                        self.view.setAudioURL(url: newURL)
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    self.view.showError(message: (error?.localizedDescription)!)
                }
            })
            downloadTask.resume()
        }else {
            self.view.setAudioURL(url: newURL)
        }
        
    }
    
    func downloadSubFromURL(url:URL, filename: String, ext: String){
        
        let file = FileManager()
        let newURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename+"Sub" + ext)
        if !file.fileExists(atPath: newURL.path){
            let downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
                if error == nil{
                    do {
                        try file.copyItem(at: URL!, to: newURL)
                        self.view.setTranscript(url: newURL)
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    self.view.showError(message: (error?.localizedDescription)!)
                }
            })
            downloadTask.resume()
        }else {
            self.view.setTranscript(url: newURL)
        }
    }
    
    func loadRunningSubFromURL(url: URL , filename: String, ext: String){
        let file = FileManager()
        let newURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename+"runSub" + ext)
        if !file.fileExists(atPath: newURL.path){
            let downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (URL, response, error) -> Void in
                if error == nil{
                    do {
                        try file.copyItem(at: URL!, to: newURL)
                        self.view.setRunningSubURL(url: newURL)
                    }catch{
                        print(error.localizedDescription)
                    }
                }else{
                    self.view.showError(message: (error?.localizedDescription)!)
                }
            })
            downloadTask.resume()
        }else {
            self.view.setRunningSubURL(url: newURL)
        }
    }
    
}
