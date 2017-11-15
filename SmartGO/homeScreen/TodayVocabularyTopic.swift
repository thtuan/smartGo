//
//  TodayVocabularyTopic.swift
//  SmartGO
//
//  Created by thanh tuan on 8/8/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import Foundation

enum TodayVocabularyTopicType {
    case normal // 0
    case hot //1
    case new // 2
}

class TodayVocabularyTopic {
    var name:String!
    var describe:String!
    var imageURL: [String] = []
    var link: String!
    var type: TodayVocabularyTopicType!
}
