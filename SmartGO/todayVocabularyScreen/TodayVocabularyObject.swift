//
//  TodayVocabularyObject.swift
//  SmartGO
//
//  Created by thanh tuan on 8/7/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import Foundation

struct VocabularyAnswer {
    var imageURL: String?
    var describe: String?
}
class TodayVocabularyObject {
    var keyWord: String!
    var speech: String!
    var answer: [VocabularyAnswer] = []
    var correctAnswer: Int!
}
