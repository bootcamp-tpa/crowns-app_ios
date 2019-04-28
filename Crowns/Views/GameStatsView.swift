//
//  GameStatsView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

@IBDesignable
class GameStatsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!

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
        
        backgroundColor = UIColor.clear
        
        addSubview(contentView)
    }

}
