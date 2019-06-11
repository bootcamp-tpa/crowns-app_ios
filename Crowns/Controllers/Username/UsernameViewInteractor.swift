//
//  UsernameViewInteractor.swift
//  Crowns
//
//  Created by Damian Kolasiński on 11/06/2019.
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import Foundation

protocol UsernameViewInteractorDelegate: AnyObject {
    func showLoadingIndicator(_ show: Bool)
    func showErrorAlert(withMessage message: String)
    func showGameController(forUser user: User)
}

class UsernameViewInteractor {
    weak var delegate: UsernameViewInteractorDelegate!
    private let webService: WebService
    private var username: String?
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func textFieldValueDidChange(to value: String?) {
        username = value
    }
    
    func didTapStartButton() {
        guard let username = username, !username.isEmpty else {
            delegate.showErrorAlert(withMessage: "Please enter the username.")
            return
        }
        attemptToCreateUser(withUsername: username)
    }
    
    private func attemptToCreateUser(withUsername username: String) {
        delegate.showLoadingIndicator(true)
        webService.createUser(
            withUsername: username,
            completion: { [delegate] result in
                delegate?.showLoadingIndicator(false)
                switch result {
                case .success(let user): delegate?.showGameController(forUser: user)
                case .failure(let error): delegate?.showErrorAlert(withMessage: error.title)
                }
        })
    }
}
