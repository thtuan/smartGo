//
//  TodayVocabularyPresenter.swift
//  SmartGO
//
//  Created by thanh tuan on 8/7/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol TodayVocabularyPresenterInput {
    func getTopicToday(link: String)
    func getRandomTopic()
}
class TodayVocabularyPresenter: TodayVocabularyPresenterInput {
    var view: TodayVocabularyPageControllerInput!
    var interactor: TodayVocabularyInteractorInput!
    
    func getRandomTopic() {
        
    }
    
    func getTopicToday(link: String) {
        interactor.getTopicToday(link: link) { (data) in
            self.view.setTodayVocabularyData(data: data.data!)
        }
    }
}
