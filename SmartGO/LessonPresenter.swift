//
//  LessonPresenter.swift
//  SmartGO
//
//  Created by thanh tuan on 7/14/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol LessonPresenterInput {
    func getLessonList(link: String)
}
class LessonPresenter: LessonPresenterInput {
    var view: LessonControllerInput!
    var interactor: LessonInteractorInput!
    
    func getLessonList(link: String) {
        interactor.getLessonList(link: link, dataResponse: { (dataResponse) in
            self.view.setView(listeningList: dataResponse.data!)
        })
    }
}
