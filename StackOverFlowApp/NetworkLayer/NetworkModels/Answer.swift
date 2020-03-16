//
//  Answer.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/16/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import Foundation

struct AnswerItems: Codable {
    var items: [Answer]
}

struct Answer: Codable {
    var owner: AnswerOwner
    var body: String
}

struct AnswerOwner: Codable {
    var userId: Int?
    var displayName: String
    var profileImage: String
}
