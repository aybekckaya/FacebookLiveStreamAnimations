//
//  EmojiViewAnimator.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 28.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit

class EmojiViewAnimation:CAAnimation {
   
    static func positionAnimation(path:CGPath , beginTime:CFTimeInterval , duration:CFTimeInterval)->CAKeyframeAnimation {
        let animationPosition = CAKeyframeAnimation(keyPath: "position")
        animationPosition.path = path
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        animationPosition.isRemovedOnCompletion = false
        animationPosition.beginTime = beginTime
        animationPosition.duration = duration
        return animationPosition
    }
    
    static  func scaleAnimation(beginTime:CFTimeInterval  , duration:CFTimeInterval , from:CGFloat = 1 , to:CGFloat = 0, springAvailable:Bool = false )->CAAnimation {
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
    
    static func opacityAnimation(beginTime:CFTimeInterval , duration:CFTimeInterval , from:CGFloat = 1 , to:CGFloat = 0  )->CABasicAnimation {
        let animationOpacity = CABasicAnimation(keyPath: "opacity")
        animationOpacity.fromValue = from
        animationOpacity.toValue = to
        animationOpacity.duration = duration
        animationOpacity.beginTime = beginTime
        animationOpacity.isRemovedOnCompletion = false
        animationOpacity.fillMode = CAMediaTimingFillMode.forwards
        return animationOpacity
    }
    
}

class EmojiViewAnimationGroup: CAAnimationGroup, CAAnimationDelegate {
    private var completion:(()->())!
    private var view:UIView!
    
    override init() {
        super.init()
    }
    
    init(animations:[CAAnimation] , view:UIView) {
        super.init()
        self.animations = animations
        self.view = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(completion:@escaping (()->())) {
        self.completion = completion
        self.delegate = self
        self.duration = durationFromAnimations(animations: self.animations)
        self.fillMode = CAMediaTimingFillMode.forwards
        self.isRemovedOnCompletion = false
        view.layer.add(self, forKey: nil)
    }
    
    private func durationFromAnimations(animations:[CAAnimation]?)->CFTimeInterval {
        guard let animations = animations else { return 0 }
        var max:CFTimeInterval = 0
        animations.forEach { anim in
            if anim.beginTime + anim.duration > max {
                max = anim.beginTime + anim.duration
            }
        }
        return max
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completion()
    }
    
}
