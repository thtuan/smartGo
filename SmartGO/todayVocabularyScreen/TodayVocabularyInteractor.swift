//
//  TodayVocabularyInteractor.swift
//  SmartGO
//
//  Created by thanh tuan on 8/7/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseDatabase
protocol TodayVocabularyInteractorInput {
    func getTopicToday(link: String, dataResponse: @escaping (DataResponse<TodayVocabularyDTO>)-> ())
}
class TodayVocabularyInteractor: TodayVocabularyInteractorInput {
    var ref: DatabaseReference!
    init() {
        ref = Database.database().reference()
    }
    
    func getTopicToday(link: String, dataResponse: @escaping (DataResponse<TodayVocabularyDTO>) -> ()){
        
        ref.child(link).observeSingleEvent(of: .value, with: { (snapshot) in
            let data = DataResponse<TodayVocabularyDTO>()
            let dto = TodayVocabularyDTO()
            print(snapshot)
            dto.append(snapshot: snapshot)
            data.data = dto
            dataResponse(data)
        })
    }
}
