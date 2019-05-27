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
    
    var image:UIImage {
        switch self {
        case .love:
            return UIImage(named: "emoji_heart")!
        case .like:
            return UIImage(named: "emoji_like")!
        }
    }
}

class EmojiView:UIView , CAAnimationDelegate {
    private var type:EmojiType = EmojiType.love
    private let imageView:UIImageView = {
        let imView:UIImageView = UIImageView(frame: .zero)
        imView.clipsToBounds = true
        return imView
    }()
    
    fileprivate(set) var path:CGPath!
    fileprivate(set) var animationGroup:CAAnimationGroup!
    private var initialPosition:CGPoint = .zero
    private var finalPosition:CGPoint = .zero
    private var oscilation:CGFloat = 0
    
    
    init(type:EmojiType , initialPosition:CGPoint , finalPosition:CGPoint , oscilation:CGFloat) {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize(width: 30, height: 30)))
        self.type = type
        self.oscilation = oscilation
        self.initialPosition = initialPosition
        self.finalPosition = finalPosition
        setUp()
        initializePath()
    }
    
    private func setUp() {
        self.addSubview(imageView)
        imageView.frame = CGRect.init(origin: .zero, size: self.frame.size)
        imageView.image = self.type.image
        self.backgroundColor = .clear
    }
    
    private func initializePath() {
        self.path = EmojiView.path(from: initialPosition, to: finalPosition, oscilation: oscilation)
        self.animationGroup = EmojiView.animation(path: self.path, durationTotal: 7)
        self.animationGroup.delegate = self
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.removeFromSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Animation Creator
extension EmojiView {
    fileprivate static func animation(path:CGPath , durationTotal:CFTimeInterval)->CAAnimationGroup {
        let animationPosition = CAKeyframeAnimation(keyPath: "position")
        animationPosition.path = path
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        animationPosition.isRemovedOnCompletion = false
        let timingFunc = CAMediaTimingFunction(controlPoints: 0.25, 0.25, 0.5, 0.75)
        animationPosition.timingFunctions = [timingFunc]
        
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.fromValue = 1
        animationOpacity.toValue = 0
        animationOpacity.duration = durationTotal*2 / 5
        animationOpacity.beginTime = durationTotal - animationOpacity.duration
        animationOpacity.isRemovedOnCompletion = false
        animationOpacity.fillMode = CAMediaTimingFillMode.forwards
        
        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        animationScale.fromValue = 1
        animationScale.toValue = 0
        animationScale.duration = durationTotal*2 / 5
        animationScale.beginTime = durationTotal - animationScale.duration
        animationScale.isRemovedOnCompletion = false
        animationScale.fillMode = CAMediaTimingFillMode.forwards
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animationPosition , animationOpacity , animationScale]
        animationGroup.duration = durationTotal
        animationGroup.fillMode =  CAMediaTimingFillMode.forwards
        animationGroup.isRemovedOnCompletion = false
        
        
        return animationGroup
    }
}


// Path Creator
extension EmojiView {
    
    fileprivate static func path(from:CGPoint , to:CGPoint , oscilation:CGFloat)->CGPath {
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

