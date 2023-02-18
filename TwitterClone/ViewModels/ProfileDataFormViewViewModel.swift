//
//  ProfileDataFormViewViewModel.swift
//  TwitterClone
//
//  Created by Ali Görkem Aksöz on 16.02.2023.
//

import Foundation
import Combine

final class ProfileDataFormViewViewModel: ObservableObject {
    
    @Published var displayName: String?
    @Published var userName: String?
    @Published var bio: String?
    @Published var avatarPath: String?
}
