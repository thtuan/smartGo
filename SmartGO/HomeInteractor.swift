//
//  HomeInteractor.swift
//  SmartGO
//
//  Created by thanh tuan on 8/8/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol HomeInteractorInput {
    func getTodayTopic(dataResponse: @escaping (DataResponse<TodayVocabularyTopic>)-> ())
    
    func getOutstandingTopic(dataResponse: @escaping (([Listening]) -> ()))
}
class HomeInteractor: HomeInteractorInput {
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    func getTodayTopic(dataResponse: @escaping (DataResponse<TodayVocabularyTopic>)-> ()) {
        
        ref.child(URLHelper.urlVocabularyTopic).observeSingleEvent(of: .value, with: { (snapshot) in
            let todayTopicDTO = TodayVocabularyTopicDTO()
            let data = DataResponse<TodayVocabularyTopic>()
            todayTopicDTO.append(snapshot: snapshot)
            if todayTopicDTO.listOfTodayTopic.count > 0{
                let random = arc4random_uniform(UInt32(todayTopicDTO.listOfTodayTopic.count))
                let randomInt = Int(random)
                data.data = todayTopicDTO.listOfTodayTopic[randomInt]
                dataResponse(data)
            }
        })
        
    }
    
    func getOutstandingTopic(dataResponse: @escaping (([Listening]) -> ())) {
        ref.child("/learn/basic/lesson/1/listen").observeSingleEvent(of: .value, with: { (snapshot) in
            var lessonList: [Listening] = []
            for level in snapshot.children {
                for row in (level as! DataSnapshot).children {
                    let firebaseData = (row as! DataSnapshot).value as? NSDictionary
                    if (firebaseData?["isOutstanding"] as?
                        Int != nil) && (firebaseData?["isOutstanding"] as! Int == 1){
                        let listening = Listening()
                        listening.name = firebaseData?["name"] as? String
                        listening.urlAudio = firebaseData?["url_audio"] as? String
                        listening.urlSub = firebaseData?["url_sub"] as? String
                        listening.urlImage = firebaseData?["url_image"] as? String
                        listening.describe = firebaseData?["describe"] as? String
                        listening.urlRunnigSub = firebaseData?["url_running_sub"] as? String
                        lessonList.append(listening)
                    }
                    
                }
            }
            
            dataResponse(lessonList)
        })
    }
}
