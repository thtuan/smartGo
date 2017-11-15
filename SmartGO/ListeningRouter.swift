//
//  ListenningRouter.swift
//  SmartGO
//
//  Created by thanh tuan on 7/12/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit

enum ScreenType {
    case learning
    case music
}
protocol ListeningRouterInput {
//    var listening: Listening?
    var screenType: ScreenType {get set}
    func setListening(data: Listening?)
    func getListening() -> Listening?
    static func getController() -> ListeningController
}
class ListeningRouter: ListeningRouterInput {
    
    private var listening: Listening?
    private var _screenType: ScreenType = .learning
    var screenType: ScreenType {
        get{
            return _screenType
        }
        set{
            _screenType = newValue
        }
    }
    func setListening(data: Listening?) {
        if data != nil  {
            self.listening = data
        }
        
    }
    func getListening() -> Listening?{
        return listening
    }
    static func getController() -> ListeningController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "listeningController") as! ListeningController
        return controller
    }
}
