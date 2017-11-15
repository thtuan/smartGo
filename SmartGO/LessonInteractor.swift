//
//  LessonInteractor.swift
//  SmartGO
//
//  Created by thanh tuan on 7/14/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseDatabase
protocol LessonInteractorInput {
    func getLessonList(link: String, dataResponse: @escaping (DataResponse<[Listening]>) -> ())
}
class LessonInteractor: LessonInteractorInput {
    
    var ref: DatabaseReference!
    init() {
        ref = Database.database().reference()
    }
    func getLessonList(link: String, dataResponse: @escaping (DataResponse<[Listening]>) -> ()) {
        ref.child(link).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let data = DataResponse<[Listening]>()
            var lessonList: [Listening] = []
            for row in snapshot.children {
                let listening = Listening()
                let firebaseData = (row as! DataSnapshot).value as? NSDictionary
                listening.name = firebaseData?["name"] as? String
                listening.urlAudio = firebaseData?["url_audio"] as? String
                listening.urlSub = firebaseData?["url_sub"] as? String
                listening.urlImage = firebaseData?["url_image"] as? String
                listening.describe = firebaseData?["describe"] as? String
                listening.urlRunnigSub = firebaseData?["url_running_sub"] as? String
                lessonList.append(listening)
            }
            data.data = lessonList
            dataResponse(data)
        })
        
    }
    
    
}
