//
//  TweetComposeViewController.swift
//  TwitterClone
//
//  Created by Ali Görkem Aksöz on 20.02.2023.
//

import UIKit
import Combine

class TweetComposeViewController: UIViewController {
    
    private var viewModel = TweetComposeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private let tweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private let tweetTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        textView.text = "What's happening?"
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Tweet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
        tweetButton.addTarget(self, action: #selector(didTapTweet), for: .touchUpInside)
        
        tweetTextView.delegate = self
        
        view.addSubview(tweetButton)
        view.addSubview(tweetTextView)
        
        bindViews()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getUserData()
    }
    
    private func bindViews() {
        viewModel.$isValidToTweet.sink { [weak self] buttonState in
            self?.tweetButton.isEnabled = buttonState
        }.store(in: &subscriptions)
        
        viewModel.$shouldDismissComposer.sink { [weak self] succes in
            if succes {
                self?.dismiss(animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapTweet() {
        viewModel.dispatchTweets()
    }
    
    private func configureConstraints() {
        
        let tweetButtonConstraints = [
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tweetButton.widthAnchor.constraint(equalToConstant: 120),
            tweetButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let tweetTextViewConstraints = [
            tweetTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tweetTextView.bottomAnchor.constraint(equalTo: tweetButton.topAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(tweetButtonConstraints)
        NSLayoutConstraint.activate(tweetTextViewConstraints)
    }
    
}

extension TweetComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.tweetContent = textView.text
        viewModel.validateToTweet()
    }
}
