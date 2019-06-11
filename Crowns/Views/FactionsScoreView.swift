//
//  FactionsScoreView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

struct FactionsScoreViewModel {
    let churchModifierMode: ModifierMode
    let commonersModifierMode: ModifierMode
    let militaryModifierMode: ModifierMode
    let merchantsModifierMode: ModifierMode
}

struct FactionScoreViewChange {
    let faction: Faction
    let score: Int
}

class FactionsScoreView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var churchScoreView: FactionScoreView!
    @IBOutlet private weak var commonersScoreView: FactionScoreView!
    @IBOutlet private weak var militaryScoreView: FactionScoreView!
    @IBOutlet private weak var merchantsScoreView: FactionScoreView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func update(withModel model: FactionsScoreViewModel) {
        churchScoreView.modifierMode = model.churchModifierMode
        commonersScoreView.modifierMode = model.commonersModifierMode
        militaryScoreView.modifierMode = model.militaryModifierMode
        merchantsScoreView.modifierMode = model.merchantsModifierMode
    }
    
    func update(withChange change: FactionScoreViewChange) {
        switch change.faction {
        case .church: churchScoreView.score = change.score
        case .commoners: commonersScoreView.score = change.score
        case .military: militaryScoreView.score = change.score
        case .merchants: merchantsScoreView.score = change.score
        }
    }
    
    private func initSubviews() {
        // standard initialization logic
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        
        backgroundColor = UIColor.clear
        
        addSubview(contentView)
        
        churchScoreView.faction = .church
        commonersScoreView.faction = .commoners
        militaryScoreView.faction = .military
        merchantsScoreView.faction = .merchants
    }
}
