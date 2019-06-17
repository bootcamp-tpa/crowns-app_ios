//
//  DeckView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class DeckView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var currentCardTitleLabel: UILabel!
    @IBOutlet private weak var cardContainerView: UIView!
    weak var cardDelegate: CardViewDelegate?
    var currentCard: CardView?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func update(withModel model: CardViewModel?) {
        if let model = model {
            initCard()
            currentCardTitleLabel.text = model.title
            currentCard?.update(withImage: model.image)
        } else {
            currentCardTitleLabel.text = nil
            currentCard?.removeFromSuperview()
            currentCard = nil
        }
    }
    
    private func initSubviews() {
        // standard initialization logic
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    private func initCard() {
        let card = CardView()
        currentCard = card
        currentCard?.delegate = self
        
        card.translatesAutoresizingMaskIntoConstraints = false
        addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            card.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor)
        ])
    }
}

extension DeckView : CardViewDelegate {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice) {
        cardDelegate?.cardView(cardView, didDisplayChoice: choice)
    }
    
    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice) {
        cardDelegate?.cardView(cardView, didFinalizeChoice: choice)
    }
}

