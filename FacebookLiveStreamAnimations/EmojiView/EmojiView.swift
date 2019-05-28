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
    //case laugh
    //case cry
    //case wow
    
    var image:UIImage {
        switch self {
        case .love:
            return UIImage(named: "emoji_heart")!
        case .like:
            return UIImage(named: "emoji_like")!
            /*
        case .cry:
            return UIImage(named: "emoji_cry")!
        case .laugh:
             return UIImage(named: "emoji_laugh")!
        case .wow:
             return UIImage(named: "emoji_wow")!
 */
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
// 243 ,185 , 66
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
    
    func addAnimationsGroup(completion:((EmojiView)->())? = nil) {
       
        let configuration = self.currentConfiguration!
        switch configuration.owner {
        case .me:
            let positionAnim:CAKeyframeAnimation = positionAnimation(path: path, beginTime: 0, duration: 0.3)
            let opacityAnim = opacityAnimation(beginTime: 0, duration: 0.3, from: 0, to: 1)
            let scaleAnim = scaleAnimation(beginTime: 0, duration: 0.3, from: 0, to: 0.7)
            let scaleAnimSpark = scaleAnimation(beginTime: 1, duration: 0.5, from: 0.7, to: 1 , springAvailable: true)
            let scaleAnimHide = scaleAnimation(beginTime: 2.5, duration: 0.3, from: 1, to: 0, springAvailable: false)
            let opacityAnimHide = opacityAnimation(beginTime: 2.5, duration: 0.3, from: 1, to: 0)
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
            let initScaleAnim = scaleAnimation(beginTime: 0, duration: 0.3, from: 0, to: 1, springAvailable: false)
            let positionAnim:CAKeyframeAnimation = positionAnimation(path: path, beginTime: 0.3, duration: 3)
            let opacityAnim:CAAnimation = opacityAnimation(beginTime: 2.3, duration: 1)
            let scaleAnim:CAAnimation = scaleAnimation(beginTime: 2.3, duration: 1)
            let arrAnimations = [initScaleAnim , positionAnim, opacityAnim , scaleAnim]
            EmojiViewAnimationGroup(animations: arrAnimations, view: self).startAnimating {
                print("completed")
            }
           
        }
    }
    

    private func opacityAnimation(beginTime:CFTimeInterval , duration:CFTimeInterval , from:CGFloat = 1 , to:CGFloat = 0  )->CABasicAnimation {
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.fromValue = from
        animationOpacity.toValue = to
        animationOpacity.duration = duration
        animationOpacity.beginTime = beginTime
        animationOpacity.isRemovedOnCompletion = false
        animationOpacity.fillMode = CAMediaTimingFillMode.forwards
        return animationOpacity
    }
    
    private  func scaleAnimation(beginTime:CFTimeInterval  , duration:CFTimeInterval , from:CGFloat = 1 , to:CGFloat = 0, springAvailable:Bool = false )->CAAnimation {
        if springAvailable == true {
            let animationScale = CASpringAnimation(keyPath: "transform.scale")
            animationScale.fromValue = from
            animationScale.toValue = to
            animationScale.duration = duration
            animationScale.beginTime = beginTime
            animationScale.damping = 0.3
            animationScale.isRemovedOnCompletion = false
            animationScale.fillMode = CAMediaTimingFillMode.forwards
            return animationScale
        }
        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        animationScale.fromValue = from
        animationScale.toValue = to
        animationScale.duration = duration
        animationScale.beginTime = beginTime
        animationScale.isRemovedOnCompletion = false
        animationScale.fillMode = CAMediaTimingFillMode.forwards
        return animationScale
    }
    
    
    private  func positionAnimation(path:CGPath , beginTime:CFTimeInterval , duration:CFTimeInterval)->CAKeyframeAnimation {
        let animationPosition = CAKeyframeAnimation(keyPath: "position")
        animationPosition.path = path
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        animationPosition.isRemovedOnCompletion = false
        animationPosition.beginTime = beginTime
        animationPosition.duration = duration
        return animationPosition
    }
    

    private func userReactionShowProfileImageToHiddenAnimation()->CABasicAnimation {
        let animationPosition = CABasicAnimation(keyPath: "transform.scale")
        animationPosition.fromValue = 1
        animationPosition.toValue = 0
        animationPosition.duration = 0.3
        animationPosition.beginTime = 2
        animationPosition.isRemovedOnCompletion = false
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        return animationPosition
    }
    
    
    private func userReactionShowPositionAnimation(configuration:EmojiViewConfiguration)->CABasicAnimation {
        let animationPosition = CABasicAnimation(keyPath: "position")
        animationPosition.fromValue = configuration.initialPosition
        animationPosition.toValue = CGPoint(x: configuration.initialPosition.x, y: configuration.initialPosition.y - 100)
        animationPosition.duration = 0.3
        animationPosition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animationPosition.isRemovedOnCompletion = false
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        return animationPosition
    }
    

    private  func userReactionShowScaleBeforeBlinkAnimation()->CASpringAnimation {
        let animationPosition = CASpringAnimation(keyPath: "transform.scale")
        animationPosition.fromValue = 0.5
        animationPosition.toValue = 1
        animationPosition.duration = 0.5
        animationPosition.beginTime = 0.5
        animationPosition.damping = 1
        animationPosition.isRemovedOnCompletion = false
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        return animationPosition
    }
    
    
    private  func userReactionShowScaleAnimation()->CABasicAnimation {
        let animationPosition = CABasicAnimation(keyPath: "transform.scale")
        animationPosition.fromValue = 0
        animationPosition.toValue = 0.5
        animationPosition.duration = 0.3
        animationPosition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animationPosition.isRemovedOnCompletion = false
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        return animationPosition
    }
    
    private func userReactionShowOpacityAnimation()->CABasicAnimation {
        let animationPosition = CABasicAnimation(keyPath: "opacity")
        animationPosition.fromValue = 0
        animationPosition.toValue = 1
        animationPosition.duration = 0.3
        animationPosition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animationPosition.isRemovedOnCompletion = false
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        return animationPosition
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

