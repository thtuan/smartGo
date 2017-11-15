//
//  ListenningInteractor.swift
//  SmartGO
//
//  Created by thanh tuan on 7/13/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol ListeningInteractorInput {
    func loadListeningInfor(link: String,  dataResponse: @escaping (DataResponse<Listening>) -> ())
}

class ListeningInteractor: ListeningInteractorInput {
    var ref: DatabaseReference!
    init() {
        ref = Database.database().reference()
    }
    
    func loadListeningInfor(link: String, dataResponse: @escaping (DataResponse<Listening>) -> ()) {
        ref.child(link).observeSingleEvent(of: .value, with: { (snapshot) in
            let data = DataResponse<Listening>()
            let dataInside = Listening()
            let firebaseData = snapshot.value as? NSDictionary
            dataInside.name = firebaseData?["name"] as? String
            dataInside.urlAudio = firebaseData?["url_audio"] as? String
            dataInside.urlSub = firebaseData?["url_sub"] as? String
            dataInside.urlRunnigSub = firebaseData?["url_running_sub"] as? String
            data.data = dataInside
            dataResponse(data)
        })
    }
   
}
