//
//  Question.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/13/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import Foundation

struct FeedResponse: Codable {
    var items: [Question]
}

struct Question: Codable {
    var questionId: Int
    var owner: Owner
    var tags: [String]
    var title: String
}

struct Owner: Codable {
//    var userId: Int16?
    var displayName: String
    var profileImage: String
}
