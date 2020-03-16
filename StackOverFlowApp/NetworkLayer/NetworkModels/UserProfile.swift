//
//  UserProfile.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/16/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import Foundation

struct UserProfileItems: Codable {
    var items: [UserProfile]
}

struct UserProfile: Codable {
    var userId: Int
    var badgeCounts: Badges
    var location: String?
    var displayName: String
    var profileImage: String?
}

struct Badges: Codable {
    var bronze: Int
    var silver: Int
    var gold: Int
}

