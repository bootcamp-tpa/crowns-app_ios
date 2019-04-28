//
//  GameViewController.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var deckView: DeckView!
    @IBOutlet weak var gameStatsView: GameStatsView!
    @IBOutlet weak var factionsScoreView: FactionsScoreView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        deckView.cardDelegate = self
        
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

