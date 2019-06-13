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
    private var interactor: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        deckView.cardDelegate = self
    }

    private func setup() {
        gameStatsView.setUsername(username: interactor.username)
    }
}

extension GameViewController : CardViewDelegate {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice) {

    }
    
    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {

    }
}

extension GameViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        controller.interactor = GameViewModel(user: user)
        return controller
    }
}
