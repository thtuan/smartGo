//
//  HomePresenter.swift
//  SmartGO
//
//  Created by thanh tuan on 8/8/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol HomePresenterInput {
    func getTodayTopic()
    func getOutstanding()
}
class HomePresenter: HomePresenterInput {
    var view: HomeControllerInput!
    var interactor: HomeInteractorInput!
    
    func getTodayTopic() {
        interactor.getTodayTopic { (data) in
            self.view.loadDataTopicView(data: data.data)
        }
    }
    
    func getOutstanding() {
        interactor.getOutstandingTopic { (outStandingData) in
            self.view.loadOutstandingData(data: outStandingData)
        }
    }
}
