//
//  GameViewController.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet private weak var deckView: DeckView!
    @IBOutlet private weak var gameStatsView: GameStatsView!
    @IBOutlet private weak var factionsScoreView: FactionsScoreView!
    private var interactor: GameViewInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        deckView.cardDelegate = self
    }

    private func setup() {
        gameStatsView.usernameLabel.text = interactor.username
    }
}

extension GameViewController : CardViewDelegate {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice) {
        switch choice {
        case .left:
            factionsScoreView.churchScoreView.modifierMode = .decrease
            factionsScoreView.merchantsScoreView.modifierMode = .decrease
            factionsScoreView.militaryScoreView.modifierMode = .increase
            factionsScoreView.commonersScoreView.modifierMode = .increase
        case .right:
            factionsScoreView.churchScoreView.modifierMode = .increase
            factionsScoreView.merchantsScoreView.modifierMode = .increase
            factionsScoreView.militaryScoreView.modifierMode = .decrease
            factionsScoreView.commonersScoreView.modifierMode = .decrease
        case .none:
            factionsScoreView.churchScoreView.modifierMode = .none
            factionsScoreView.merchantsScoreView.modifierMode = .none
            factionsScoreView.militaryScoreView.modifierMode = .none
            factionsScoreView.commonersScoreView.modifierMode = .none
        }
    }
    
    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        factionsScoreView.churchScoreView.modifierMode = .none
        factionsScoreView.merchantsScoreView.modifierMode = .none
        factionsScoreView.militaryScoreView.modifierMode = .none
        factionsScoreView.commonersScoreView.modifierMode = .none
    }
}

extension GameViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let controller: GameViewController = .instantiate(storyboardId: "GameViewController")
        controller.interactor = GameViewInteractor(user: user)
        return controller
    }
}
