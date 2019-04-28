//
//  DeckView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class DeckView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var cardDelegate : CardViewDelegate?
    var currentCard : CardView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        initCard()
    }
    
    func initCard() {
        let card = CardView.init(frame: self.bounds)
        currentCard = card
        currentCard?.delegate = self
        addSubview(card)
    }
    
    override func layoutSubviews() {
        self.currentCard?.frame = self.bounds
        super.layoutSubviews()
    }
}

extension DeckView : CardViewDelegate {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice) {
        cardDelegate?.cardView(cardView, didDisplayChoice: choice)
    }
    
    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        cardDelegate?.cardView(cardView, didFinalizeChoice: choice)
        initCard()
    }
}

