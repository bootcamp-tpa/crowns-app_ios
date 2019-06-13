//
//  ScoreView.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

class ScoreView: UIView {

    private let valueLayer = CALayer()
    private let shapeLayer = CALayer()
    
    var image : CGImage? {
        didSet {
            shapeLayer.contents = image
        }
    }
    
    var percentage : NSNumber = 0.5 {
        didSet {
            valueLayer.setNeedsLayout()
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
        let valueColor = UIColor(red:0.38, green:0.45, blue:0.38, alpha:1).cgColor
        let backgroundColor = UIColor(red:0.83, green:0.98, blue:0.84, alpha:1)
        
        self.backgroundColor = backgroundColor
        valueLayer.backgroundColor = valueColor
        
        shapeLayer.contentsGravity = .resizeAspect
        layer.mask = shapeLayer
        layer.addSublayer(valueLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let percentageToValue = bounds.height * CGFloat(truncating: percentage);
        let valueFrame = CGRect(x: 0, y: bounds.height - percentageToValue, width: bounds.width, height: percentageToValue)
        valueLayer.frame = valueFrame
        shapeLayer.frame = bounds
    }

}
