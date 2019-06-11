//
//  GameStatsView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

struct GameStatsViewModel {
    let score: String
    let years: String
}

class GameStatsView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var yearsLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func setUsername(username: String) {
        usernameLabel.text = username
    }
    
    func update(withModel model: GameStatsViewModel) {
        scoreLabel.text = model.score
        yearsLabel.text = model.years
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
    }
}
