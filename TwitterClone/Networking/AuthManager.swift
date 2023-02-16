//
//  AuthManager.swift
//  TwitterClone
//
//  Created by Ali Görkem Aksöz on 15.02.2023.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

class AuthManager {
    static let shared = AuthManager()
    private init() { }
    
    func registerUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        return  Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
    func loginUser(with email: String, password: String) -> AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
}
