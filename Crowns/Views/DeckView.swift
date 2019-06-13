//
//  DeckView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class DeckView: UIView {
    
    weak var cardDelegate: CardViewDelegate?
    var currentCard: CardView?
    
    override func layoutSubviews() {
        self.currentCard?.frame = self.bounds
        super.layoutSubviews()
    }
    
    func update(withModel model: CardViewModel?) {
        if let model = model {
            if currentCard == nil { initCard() }
            currentCard?.update(withModel: model)
        } else {
            currentCard?.removeFromSuperview()
            currentCard = nil
        }
    }
    
    private func initCard() {
        let card = CardView(frame: self.bounds)
        currentCard = card
        currentCard?.delegate = self
        addSubview(card)
    }
}

extension DeckView : CardViewDelegate {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice) {
        cardDelegate?.cardView(cardView, didDisplayChoice: choice)
    }
    
    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        if choice != .none { initCard() }
        cardDelegate?.cardView(cardView, didFinalizeChoice: choice)
    }
}

