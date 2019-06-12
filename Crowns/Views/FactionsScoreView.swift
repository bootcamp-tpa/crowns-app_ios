//
//  FactionsScoreView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

struct FactionsScoreViewModes {
    let churchModifierMode: ModifierMode
    let commonersModifierMode: ModifierMode
    let militaryModifierMode: ModifierMode
    let merchantsModifierMode: ModifierMode
    
    static var none: FactionsScoreViewModes {
        return FactionsScoreViewModes(
            churchModifierMode: .none,
            commonersModifierMode: .none,
            militaryModifierMode: .none,
            merchantsModifierMode: .none
        )
    }
}

struct FactionsScoreViewModel {
    let churchScore: Int
    let commonersScore: Int
    let militaryScore: Int
    let merchantsScore: Int
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
    
    func update(withModes modes: FactionsScoreViewModes) {
        churchScoreView.modifierMode = modes.churchModifierMode
        commonersScoreView.modifierMode = modes.commonersModifierMode
        militaryScoreView.modifierMode = modes.militaryModifierMode
        merchantsScoreView.modifierMode = modes.merchantsModifierMode
    }
    
    func update(withModel model: FactionsScoreViewModel) {
        churchScoreView.score = model.churchScore
        commonersScoreView.score = model.commonersScore
        militaryScoreView.score = model.militaryScore
        merchantsScoreView.score = model.merchantsScore
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
