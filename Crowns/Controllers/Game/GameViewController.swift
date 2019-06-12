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
    private var viewModel: GameViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUsername()
        deckView.cardDelegate = self
        viewModel.viewDidLoad()
    }

    private func setUsername() {
        gameStatsView.setUsername(username: viewModel.username)
    }
}

extension GameViewController : CardViewDelegate {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice) {
        let choiceName = viewModel.choiceName(for: choice)
        cardView.update(withChoiceName: choiceName)

        let factionsScoreViewModel = viewModel.factionsScoreViewModel(for: choice)
        factionsScoreView.update(withModel: factionsScoreViewModel)
    }

    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        viewModel.didSwipeCard(withChoice: choice)
    }
}

extension GameViewController: GameViewModelDelegate {
    func updateFactionsScore(withChange change: FactionScoreViewChange) {
        factionsScoreView.update(withChange: change)
    }

    func updateCard(withModel model: CardViewModel) {
        deckView.currentCard?.update(withModel: model)
    }

    func updateGameStats(withModel model: GameStatsViewModel) {
        gameStatsView.update(withModel: model)
    }
    
    func showDeathController(forUser user: User, kingAge: Int) {
        let controller = DeathViewController.instantiate(withUser: user, kingAge: kingAge)
        present(controller, animated: true)
    }
}

extension GameViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        let viewModel = GameViewModel(user: user)
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}
