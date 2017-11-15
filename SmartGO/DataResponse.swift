//
//  DataResponse.swift
//  SmartGO
//
//  Created by thanh tuan on 7/13/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

class DataResponse<T: Any> {
    var data: T?
    var error: NSError?
//    var data: T {
//        get {
//            if _data == nil{
//                return 0 as! T
//            }else {
//                return _data!
//            }
//        }
//        set {
//            _data = newValue
//        }
//    }
//    var error: NSError {
//        get{
//            return _error!
//        }
//        set{
//            _error = newValue
//        }
//    }
    
}
