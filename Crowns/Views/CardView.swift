//
//  CardView.swift
//  Crowns
//

//  Copyright © 2019 halftonedesign. All rights reserved.
//

import UIKit

enum Choice {
    case none
    case left
    case right
}

protocol CardViewDelegate: AnyObject {
    func cardView(_ cardView: CardView, didDisplayChoice choice: Choice)
    func cardView(_ cardView: CardView, didFinalizeChoice choice: Choice)
}

struct CardViewModel {
    let title: String
    let image: String
}

class CardView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var choiceBackgroundView: UIView!
    @IBOutlet private weak var currentChoiceLabel: UILabel!
    @IBOutlet private weak var cardImage: UIImageView!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var appliedTranslation: CGFloat = 0
    var recognizedChoice: Choice = .none
    var displayingChoice: Choice = .none

    weak var delegate: CardViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func update(withImage image: String) {
        cardImage.image = UIImage(named: image)
    }
    
    func update(withChoiceName name: String?) {
        currentChoiceLabel.text = name
    }
    
    private func initSubviews() {
        // standard initialization logic
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds

        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red:0.86, green:0.5, blue:0.4, alpha:1)
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:0.5).cgColor
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 4
        
        addSubview(contentView)
    }
    
    @IBAction private func handlePan(_ gestureRecognizer : UIPanGestureRecognizer) {
        let maxMovementValue = frame.width / 5.0
        var move : CATransform3D?
        var rotate : CATransform3D?
        
        switch gestureRecognizer.state {
        case .changed:
            let velocity = gestureRecognizer.velocity(in: nil)
            let slideFactor = velocity.x * 0.005
            
            appliedTranslation += slideFactor
            appliedTranslation = min(maxMovementValue, appliedTranslation)
            appliedTranslation = max(appliedTranslation, -maxMovementValue)
            
            let completeness = appliedTranslation / maxMovementValue
            
            if completeness == 1 {
                recognizedChoice = .right
            } else if completeness == -1 {
                recognizedChoice = .left
            } else {
                recognizedChoice = .none
            }
            
            if completeness > 0 {
                displayChoice(.right)
            } else if completeness < 0 {
                displayChoice(.left)
            }
            
            move = CATransform3DMakeTranslation(appliedTranslation, 0, 0);
            let degrees = 5 * completeness
            let radians = CGFloat(degrees * .pi / 180)
            rotate = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        case .ended:
            if recognizedChoice != .none {
                delegate?.cardView(self, didFinalizeChoice: recognizedChoice)
                completeChoice()
            } else {
                fallthrough
            }
        default:
            displayChoice(.none)
            move = CATransform3DMakeTranslation(0, 0, 0);
            rotate = CATransform3DMakeRotation(0.0, 0.0, 0.0, 1.0)
            appliedTranslation = 0
        }
        if let actualMove = move, let actualRotate = rotate {
            layer.transform = CATransform3DConcat(actualMove, actualRotate)
        }
        
    }
    
    private func displayChoice(_ choice: Choice) {
        switch choice {
        case .left: currentChoiceLabel.textAlignment = .right
        case .right: currentChoiceLabel.textAlignment = .left
        case .none: break
        }
        
        if choice == .none {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.choiceBackgroundView.alpha = 0
            }, completion: nil)
        } else if choice != displayingChoice {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.choiceBackgroundView.alpha = 1
            }, completion: nil)
        }
        displayingChoice = choice
        delegate?.cardView(self, didDisplayChoice: choice)
    }
    
    private func completeChoice() {
        let direction = CGFloat(recognizedChoice == .left ? -1.0 : 1.0)
        let finalXPosition = direction * (frame.width * 0.66)
        let finalDegrees = 10 * direction
        let finalRadians = CGFloat(finalDegrees * .pi / 180)
        
        let move = CATransform3DMakeTranslation(finalXPosition, 0.0, 0)
        let rotate = CATransform3DMakeRotation(finalRadians, 0.0, 0.0, 1.0)
        let finalTransform = CATransform3DConcat(move, rotate)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.layer.opacity = 0
            self.layer.transform = finalTransform
        }, completion: { (finished : Bool) in
          self.removeFromSuperview()
        })
    }

}
