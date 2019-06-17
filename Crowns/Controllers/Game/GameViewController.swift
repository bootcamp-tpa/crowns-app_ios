//
//  GameViewController.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var deckView: DeckView!
    @IBOutlet private weak var gameStatsView: GameStatsView!
    @IBOutlet private weak var factionsScoreView: FactionsScoreView!
    private var viewModel: GameViewModel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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

        let factionsModes = viewModel.factionsScoreViewModes(for: choice)
        factionsScoreView.update(withModes: factionsModes)
    }

    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        viewModel.didSwipeCard(withChoice: choice)
        factionsScoreView.update(withModes: .none)
    }
}

extension GameViewController: GameViewModelDelegate {
    func updateFactionsScore(withModel model: FactionsScoreViewModel) {
        factionsScoreView.update(withModel: model)
    }

    func updateCard(withModel model: CardViewModel?) {
        deckView.update(withModel: model)
    }

    func updateGameStats(withModel model: GameStatsViewModel) {
        gameStatsView.update(withModel: model)
    }
    
    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func showDeathController(forUser user: User, finishedGame: Game) {
        let controller = DeathViewController.instantiate(withUser: user, finishedGame: finishedGame)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension GameViewController {
    static func instantiate(withUser user: User) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        let viewModel = GameViewModel(
            user: user,
            storage: JSONStorageImp(),
            webService: WebServiceImp()
        )
        controller.viewModel = viewModel
        viewModel.delegate = controller
        return controller
    }
}
