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
    //private(set) var currentBeginTime:CFTimeInterval
    // private(set) var currentDuration:CFTimeInterval
    
    init(beginTime:CFTimeInterval , duration:CFTimeInterval) {
       super.init()
       self.beginTime = beginTime
       self.duration = duration
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
