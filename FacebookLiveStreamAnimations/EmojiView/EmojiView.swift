//
//  EmojiView.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 27.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit

enum EmojiType:CaseIterable {
    case love
    case like
    case laugh
    case cry
    case wow
    
    var image:UIImage {
        switch self {
        case .love:
            return UIImage(named: "emoji_heart")!
        case .like:
            return UIImage(named: "emoji_like")!
        case .cry:
            return UIImage(named: "emoji_cry")!
        case .laugh:
             return UIImage(named: "emoji_laugh")!
        case .wow:
             return UIImage(named: "emoji_wow")!
        }
    }
}

enum EmojiOwner {
    case me
    case friend
    case other
}


struct EmojiViewConfiguration {
    var owner:EmojiOwner = EmojiOwner.other
    var oscilation:CGFloat = 120
    var itemSize:CGFloat = 30
    var duration:CFTimeInterval = 7
    var initialPosition:CGPoint = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height)
    var finalPosition:CGPoint = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 0)
    var emojiType:EmojiType = EmojiType.like
    
    static let defaultConfiguration:EmojiViewConfiguration = {
        return EmojiViewConfiguration()
    }()
    
}

class EmojiView:UIView {
    
    static let heightConstraintValue:CGFloat = 500
    static let widthConstraintValue:CGFloat = 120 
    static let blinkStartColor:UIColor = #colorLiteral(red: 0.9529411765, green: 0.7254901961, blue: 0.2588235294, alpha: 1)
    static let blinkEndColor:UIColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    
    private var type:EmojiType = EmojiType.love
    
    private let imageView:UIImageView = {
        let imView:UIImageView = UIImageView(frame: .zero)
        imView.clipsToBounds = true
        imView.contentMode = UIView.ContentMode.scaleAspectFill
        return imView
    }()
    
    private let imageViewProfile:UIImageView = {
        let imView:UIImageView = UIImageView(frame: .zero)
        imView.clipsToBounds = true
        imView.contentMode = UIView.ContentMode.scaleAspectFill
        return imView
    }()
    
    fileprivate(set) var path:CGPath!
    
    private var currentConfiguration:EmojiViewConfiguration?
    
    init(configuration:EmojiViewConfiguration = EmojiViewConfiguration.defaultConfiguration) {
        super.init(frame: .zero)
        self.currentConfiguration = configuration
        setUp()
        initializePath()
    }
    
    func addTo(view:UIView) {
        view.addSubview(self)
        self.center = CGPoint(x: EmojiView.widthConstraintValue/2, y: EmojiView.heightConstraintValue)
        self.addAnimationsGroup()
    }
    
    private func setUp() {
        self.backgroundColor = .clear
        let configuration:EmojiViewConfiguration = self.currentConfiguration ?? EmojiViewConfiguration.defaultConfiguration
        self.type =  configuration.emojiType
        self.frame = CGRect.init(origin: .zero, size: CGSize(width: configuration.itemSize, height: configuration.itemSize))
        self.addSubview(imageView)
        imageView.frame = CGRect.init(origin: .zero, size: self.frame.size)
        imageView.image = self.type.image
        self.addSubview(imageViewProfile)
        imageViewProfile.frame = CGRect(origin: .zero, size: self.frame.size)
        imageViewProfile.layer.cornerRadius = self.frame.size.width / 2
        imageViewProfile.layer.masksToBounds = true
        if configuration.owner == .me {
            self.bringSubviewToFront(imageViewProfile)
            imageViewProfile.image = User.me.profileImage
        }
        else {
            self.bringSubviewToFront(imageView)
        }
    }
    
    private func initializePath() {
        let configuration = self.currentConfiguration!
        self.path = EmojiView.path(configuration: configuration)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Animation Creator
extension EmojiView: CAAnimationDelegate {
    
    fileprivate func addAnimationsGroup() {
       
        let configuration = self.currentConfiguration!
        switch configuration.owner {
        case .me:
            let positionAnim:CAKeyframeAnimation = EmojiViewAnimation.positionAnimation(path: path, beginTime: 0, duration: 0.3)
            let opacityAnim = EmojiViewAnimation.opacityAnimation(beginTime: 0, duration: 0.3, from: 0, to: 1)
            let scaleAnim = EmojiViewAnimation.scaleAnimation(beginTime: 0, duration: 0.3, from: 0, to: 0.7)
            let scaleAnimSpark = EmojiViewAnimation.scaleAnimation(beginTime: 1, duration: 0.5, from: 0.7, to: 1 , springAvailable: true)
            let scaleAnimHide = EmojiViewAnimation.scaleAnimation(beginTime: 2.5, duration: 0.3, from: 1, to: 0, springAvailable: false)
            let opacityAnimHide = EmojiViewAnimation.opacityAnimation(beginTime: 2.5, duration: 0.3, from: 1, to: 0)
            let arrAnimations = [positionAnim , opacityAnim , scaleAnim , scaleAnimSpark , scaleAnimHide , opacityAnimHide]
            EmojiViewAnimationGroup(animations: arrAnimations, view: self).startAnimating {
                var currentConfig = self.currentConfiguration!
                currentConfig.owner = .other
                let from = self.currentConfiguration!.initialPosition
                let pt = CGPoint(x: from.x, y: from.y - 100)
                currentConfig.initialPosition = pt
                let emojiView = EmojiView(configuration: currentConfig)
                emojiView.center = pt
                self.superview?.addSubview(emojiView)
                emojiView.addAnimationsGroup()
                self.removeFromSuperview()
            }
        default:
            let initScaleAnim = EmojiViewAnimation.scaleAnimation(beginTime: 0, duration: 0.3, from: 0, to: 1, springAvailable: false)
            let positionAnim:CAKeyframeAnimation = EmojiViewAnimation.positionAnimation(path: path, beginTime: 1.3, duration: 3)
            let opacityAnim:CAAnimation = EmojiViewAnimation.opacityAnimation(beginTime: 3.3, duration: 1)
            let scaleAnim:CAAnimation = EmojiViewAnimation.scaleAnimation(beginTime: 3.3, duration: 1)
            let arrAnimations = [initScaleAnim , positionAnim, opacityAnim , scaleAnim]
            EmojiViewAnimationGroup(animations: arrAnimations, view: self).startAnimating {
                print("completed")
            }
        }
    }

}


// Path Creator
extension EmojiView {
    
    fileprivate static func path(configuration:EmojiViewConfiguration)->CGPath {
        let from = configuration.initialPosition
        let to = configuration.finalPosition
        let oscilation = configuration.oscilation
        if configuration.owner == .me {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: from)
            let toLocation = CGPoint(x: from.x, y: from.y - 100)
            bezierPath.addLine(to: toLocation)
             return bezierPath.cgPath
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: from)
        
        let diff = abs(Int(to.y) - Int(from.y))
        let heightDifference:CGFloat = CGFloat(diff)
        let firstControlPointY:CGFloat = CGFloat( Int.random(in: 0..<Int(heightDifference) ))
        let firstControlPointX:CGFloat = from.x + CGFloat(Int.random(in: (-1)*Int(oscilation)..<Int(oscilation)))
        
        let secondControlPointY:CGFloat = CGFloat( Int.random(in: 0..<Int(heightDifference) ))
        let secondControlPointX:CGFloat = to.x + CGFloat(Int.random(in: (-1)*Int(oscilation)..<Int(oscilation)))
        
        let cnt1 = CGPoint(x: firstControlPointX , y: firstControlPointY)
        let cnt2 = CGPoint(x: secondControlPointX , y: secondControlPointY)
        bezierPath.addCurve(to: to, controlPoint1: cnt1, controlPoint2: cnt2)
        
        return bezierPath.cgPath
    }
}

