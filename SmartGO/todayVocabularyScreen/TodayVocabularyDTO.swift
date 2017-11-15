//
//  TodayVocabularyDTO.swift
//  SmartGO
//
//  Created by thanh tuan on 8/7/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import Foundation
import FirebaseDatabase
class TodayVocabularyDTO {
    var listOfToday: [TodayVocabularyObject] = []
    
    func append(snapshot: DataSnapshot ){
        for row in snapshot.children {
            let todayObject = TodayVocabularyObject()
            let firebaseData = (row as! DataSnapshot).value as? NSDictionary
            todayObject.keyWord = firebaseData?["keyword"] as? String
            todayObject.speech = firebaseData?["speech"] as? String
            todayObject.correctAnswer = firebaseData?["correctAnswer"] as? Int
            
            let answer1 = firebaseData?["answer1"] as? NSDictionary
            let answer2 = firebaseData?["answer2"] as? NSDictionary
            let answer3 = firebaseData?["answer3"] as? NSDictionary
            let answer4 = firebaseData?["answer4"] as? NSDictionary
            
            var todayAnswer1 = VocabularyAnswer()
            var todayAnswer2 = VocabularyAnswer()
            var todayAnswer3 = VocabularyAnswer()
            var todayAnswer4 = VocabularyAnswer()
            
            todayAnswer1.imageURL = answer1?["imageURL"] as? String
            todayAnswer1.describe = answer1?["describe"] as? String
            
            todayAnswer2.imageURL = answer2?["imageURL"] as? String
            todayAnswer2.describe = answer2?["describe"] as? String
            
            todayAnswer3.imageURL = answer3?["imageURL"] as? String
            todayAnswer3.describe = answer3?["describe"] as? String
            
            todayAnswer4.imageURL = answer4?["imageURL"] as? String
            todayAnswer4.describe = answer4?["describe"] as? String
            
            todayObject.answer.append(todayAnswer1)
            todayObject.answer.append(todayAnswer2)
            todayObject.answer.append(todayAnswer3)
            todayObject.answer.append(todayAnswer4)
            
            listOfToday.append(todayObject)
        }
    }
}
