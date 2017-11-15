//
//  TodayVocabularyTopicDTO.swift
//  SmartGO
//
//  Created by thanh tuan on 8/8/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import Foundation
import FirebaseDatabase
class TodayVocabularyTopicDTO {
    var listOfTodayTopic: [TodayVocabularyTopic] = []
    func append(snapshot: DataSnapshot ){
        for row in snapshot.children {
            let todayVocabularyTopic = TodayVocabularyTopic()
            let firebaseData = (row as! DataSnapshot).value as? NSDictionary
            todayVocabularyTopic.name = firebaseData?["name"] as? String
            todayVocabularyTopic.describe = firebaseData?["describe"] as? String
            todayVocabularyTopic.link = firebaseData?["link"] as? String
            if let type = firebaseData?["type"] as? Int {
                switch type {
                case 0:
                    todayVocabularyTopic.type = .normal
                case 1:
                    todayVocabularyTopic.type = .hot
                case 2:
                    todayVocabularyTopic.type = .new
                default:
                    todayVocabularyTopic.type = .normal
                }
            }
            if let images = firebaseData?["image"] as? NSDictionary{
                for image in images{
                    todayVocabularyTopic.imageURL.append(image.value as! String)
                }
            }
            
            listOfTodayTopic.append(todayVocabularyTopic)
        }
    }
}
