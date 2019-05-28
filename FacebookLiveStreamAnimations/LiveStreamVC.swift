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
    
    fileprivate let viewEmojiContainer:UIView = {
        let view:UIView = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let viewReactionsContainer:UIView = {
        let view:UIView = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let vcReactions:ReactionVC = ReactionVC(nibName: "ReactionVC", bundle: nil)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setUpDisplayLink()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
      //  setUpDisplayLink()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setUpUI() {
        self.view.addSubview(viewEmojiContainer)
        viewEmojiContainer.addSnapConstraints(baseView: self.view, top: nil, bottom: 0, leading: nil, trailing: 0)
        viewEmojiContainer.addLengthConstraints(height: EmojiView.heightConstraintValue, width: EmojiView.widthConstraintValue)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addUserReactionEmoji))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func addUserReactionEmoji() {
        let initPos = CGPoint(x: EmojiView.widthConstraintValue/2, y: EmojiView.heightConstraintValue)
        let finalPos = CGPoint(x: initPos.x, y: 0)
        let type = EmojiType.allCases.randomElement()!
        let configuration = EmojiViewConfiguration(owner:EmojiOwner.me, oscilation: 120, itemSize: 30, duration: 7, initialPosition: initPos, finalPosition: finalPos, emojiType: type )
        let emojiView = EmojiView(configuration: configuration)
        emojiView.center = CGPoint(x: EmojiView.widthConstraintValue/2, y: EmojiView.heightConstraintValue)
        self.viewEmojiContainer.addSubview(emojiView)
        let animation = emojiView.animationGroup
        emojiView.layer.add(animation!, forKey: nil)
    
    }
    
    
    private func setUpDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayLink))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.common)
    }
    
    @objc private func updateDisplayLink() {
        let currentTime = CACurrentMediaTime()*1000
        let seed = Int.random(in: 1..<200)
        guard Int(currentTime) % seed == 0 else { return }
        addEmojiView()
    }
  

}


/// EMOJI VIEW
extension LiveStreamVC {
    @objc fileprivate func addEmojiView() {
        let initPos = CGPoint(x: EmojiView.widthConstraintValue/2, y: EmojiView.heightConstraintValue)
        let finalPos = CGPoint(x: initPos.x, y: 0)
        let type = EmojiType.allCases.randomElement()!
        let configuration = EmojiViewConfiguration(owner:EmojiOwner.other, oscilation: 120, itemSize: 30, duration: 7, initialPosition: initPos, finalPosition: finalPos, emojiType: type )
        let emojiView = EmojiView(configuration: configuration)
        emojiView.center = CGPoint(x: EmojiView.widthConstraintValue/2, y: EmojiView.heightConstraintValue)
        self.viewEmojiContainer.addSubview(emojiView)
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


