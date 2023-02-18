//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Ali Görkem Aksöz on 16.02.2023.
//

import Foundation
import Firebase
import FirebaseFirestoreCombineSwift
import FirebaseFirestoreSwift
import Combine

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    let db = Firestore.firestore()
    let usersPath: String = "users"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap { 
                try $0.data(as: TwitterUser.self)
            }
            .eraseToAnyPublisher()
    }
}
