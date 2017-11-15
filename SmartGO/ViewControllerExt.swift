//
//  ViewControllerExt.swift
//  SmartGO
//
//  Created by thanh tuan on 7/25/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
extension UIImageView{
    func rotateImage( ) {
        if self.layer.animation(forKey: "cdImage") == nil {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation.toValue = Double.pi * 2
            rotateAnimation.duration = 13
            rotateAnimation.repeatCount = HUGE
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            self.layer.speed = 1.0
            self.layer.add(rotateAnimation, forKey: "cdImage")
        }else{
            resumeRotateImage()
        }
    }
    func pauseRotateImage() {
        let pauseTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.speed = 0.0
        self.layer.timeOffset = pauseTime
    }
    func resumeRotateImage() {
        let pauseTime = self.layer.timeOffset
        self.layer.speed = 1.0
        self.layer.timeOffset = 0.0
        self.layer.beginTime = 0.0
        self.layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        
    }
    func removeRotateImage() {
        self.layer.removeAllAnimations()
    }
}

extension UIViewController{
    func getActivityIndicatorView() -> NVActivityIndicatorView {
//        let x = self.view.center.x - 20
//        let y = self.view.center.y - 100
//        let frame = CGRect(x: x, y: y, width: 40, height: 40)
//        let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0), padding: CGFloat(0))
        return rootActivityIndicatorView
    }
    var rootActivityIndicatorView: NVActivityIndicatorView{
        get {
            let x = self.view.center.x - 20
            let y = self.view.center.y - 100
            let frame = CGRect(x: x, y: y, width: 40, height: 40)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0), padding: CGFloat(0))
            self.view.addSubview(activityIndicatorView)
            return activityIndicatorView
        }
    }
}
