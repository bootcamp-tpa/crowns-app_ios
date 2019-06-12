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
        let choiceName = interactor.choiceName(for: choice)
        cardView.update(withChoiceName: choiceName)

        let factionsScoreViewModel = interactor.factionsScoreViewModel(for: choice)
        factionsScoreView.update(withModel: factionsScoreViewModel)
    }

    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        factionsScoreView.update(withModel: .empty)
        switch choice {
        case .none: break
        case .left: interactor.didSwipeCardToLeft()
        case .right: interactor.didSwipeCardToRight()
        }

    }
}

extension GameViewController: GameViewInteractorDelegate {
    func updateFactionsScore(withChange change: FactionScoreViewChange) {
        factionsScoreView.update(withChange: change)
    }

    func updateCard(withModel model: CardViewModel) {
        deckView.currentCard?.update(withModel: model)
    }

    func updateGameStats(withModel model: GameStatsViewModel) {
        gameStatsView.update(withModel: model)
    }
}

extension GameViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        controller.interactor = interactor
        interactor.delegate = controller
        return controller
    }
}
