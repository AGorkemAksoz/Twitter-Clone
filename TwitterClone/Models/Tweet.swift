//
//  Tweet.swift
//  TwitterClone
//
//  Created by Ali Görkem Aksöz on 21.02.2023.
//

import Foundation


struct Tweet: Codable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
