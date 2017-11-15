//
//  LessonRouter.swift
//  SmartGO
//
//  Created by thanh tuan on 7/14/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol LessonRouterInput {
    func navigationTo(source: UIViewController, destination: ListeningController, listening: Listening)
    func setLessonList(lessonList: [Listening])
    
}


class LessonRouter: LessonRouterInput {
    var listLesson: [Listening]?
    
    func navigationTo(source: UIViewController, destination: ListeningController, listening: Listening) {
        destination.router.setListening(data: listening)
//        controller.present(destination, animated: true) { 
//        }
    }
    func setLessonList(lessonList: [Listening]) {
        self.listLesson = lessonList
    }

}
