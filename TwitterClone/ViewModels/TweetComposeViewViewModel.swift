//
//  TweetComposeViewViewModel.swift
//  TwitterClone
//
//  Created by Ali Görkem Aksöz on 21.02.2023.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetComposeViewViewModel: ObservableObject {
    
    private var subscriptions: Set<AnyCancellable> = []
    private var user: TwitterUser?
    
    @Published var isValidToTweet: Bool = false
    @Published var error: String = ""
    @Published var shouldDismissComposer: Bool = false
    
    var tweetContent: String = ""
    
    func getUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retreive: userID)
            .sink { [weak self ] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [unowned self] twitterUser in
                self.user = twitterUser
            }
            .store(in: &subscriptions)

    }
    
    func validateToTweet() {
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func dispatchTweets() {
        guard let user = user else { return }
        let tweet = Tweet(author: user, authorID: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.collectionTweets(dispatch: tweet)
            .sink { [weak self ] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.shouldDismissComposer = state
            }
            .store(in: &subscriptions)

    }
}
