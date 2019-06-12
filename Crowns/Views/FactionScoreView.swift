//
//  FactionScoreView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

enum ModifierMode {
    case none
    case decrease
    case increase
}

class FactionScoreView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var circleIndicator: UIView!
    @IBOutlet weak var factionSymbol: ScoreView!

    private let circleIndicatorLayer = CAShapeLayer()
    
    var faction: Faction = .church {
        didSet {
            factionSymbol.image = UIImage.init(imageLiteralResourceName: faction.asset()).cgImage
        }
    }

    var score: Int = 50 {
        didSet {
            let percentage = NSNumber(value: score / 100)
            factionSymbol.percentage = percentage
        }
    }

    var modifierMode: ModifierMode = .none {
        didSet {
            switch modifierMode {
            case .none:
                circleIndicatorLayer.path = nil
            case .decrease:
                circleIndicatorLayer.path = UIBezierPath(ovalIn: CGRect(x: 2.5, y: 2.5, width: 10, height: 10)).cgPath;
            case .increase:
                circleIndicatorLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 15, height: 15)).cgPath;
            }
        }
    }
    
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
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.frame = bounds

        let backgroundColor = UIColor(red:0.83, green:0.98, blue:0.84, alpha:1)
        circleIndicatorLayer.fillColor = backgroundColor.cgColor
        circleIndicator.layer.addSublayer(circleIndicatorLayer)
        
        addSubview(contentView)
    }
}

private extension Faction {
    func asset() -> String {
        switch self {
        case .church:
            return "church-mask"
        case .commoners:
            return "commoners-mask"
        case .merchants:
            return "merchants-mask"
        case .military:
            return "military-mask"
        }
    }
}
