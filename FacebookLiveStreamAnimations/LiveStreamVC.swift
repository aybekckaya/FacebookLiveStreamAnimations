//
//  LiveStreamVC.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 27.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class LiveStreamVC: UIViewController {

    private var displayLink:CADisplayLink?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDisplayLink()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUpDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayLink))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.common)
    }
    
    @objc private func updateDisplayLink() {
        let currentTime = CACurrentMediaTime()*1000
        let seed = Int.random(in: 1..<30)
        guard Int(currentTime) % seed == 0 else { return }
        addEmojiView()
    }
  

}


/// EMOJI VIEW
extension LiveStreamVC {
    @objc fileprivate func addEmojiView() {
        let initPos = CGPoint(x: self.view.center.x, y: self.view.frame.size.height)
        let finalPos = CGPoint(x: self.view.center.x, y: 0)
        let type = EmojiType.allCases.randomElement()!
        let emojiView = EmojiView(type: type, initialPosition: initPos, finalPosition: finalPos, oscilation: 120)
        emojiView.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height)
        self.view.addSubview(emojiView)
        let animation = emojiView.animationGroup
        emojiView.layer.add(animation!, forKey: nil)
        // debugPath(path: emojiView.path)
    }
    
    
    private func debugPath(path:CGPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 2
        self.view.layer.addSublayer(shapeLayer)
    }
}
