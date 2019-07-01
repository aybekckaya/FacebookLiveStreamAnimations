//
//  LiveStreamVC.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 27.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class LiveStreamVC: UIViewController , ReactionVCDelegate{

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
    
    private var reactionContainerViewBottomConstraint:NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications(notification:)), name:  UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotifications(notification:)), name:  UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpDisplayLink()
    }
    
    
    @objc private func handleKeyboardNotifications(notification:Notification) {
        guard let userInfo = notification.userInfo , let keyboardFrame:CGRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect  else { return  }
        reactionContainerViewBottomConstraint.constant = (-1) * (self.view.frame.size.height - keyboardFrame.origin.y)
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setUpUI() {
      
        self.view.addSubview(viewEmojiContainer)
        viewEmojiContainer.addSnapConstraints(baseView: self.view, top: nil, bottom: 0, leading: nil, trailing: 0)
        viewEmojiContainer.addLengthConstraints(height: EmojiView.heightConstraintValue, width: EmojiView.widthConstraintValue)
        
        self.view.addSubview(viewReactionsContainer)
        viewReactionsContainer.addSnapConstraints(baseView: self.view, top: nil, bottom: nil, leading: 0, trailing: 0)
        viewReactionsContainer.addLengthConstraints(height: 55, width: nil)
        viewReactionsContainer.backgroundColor = UIColor.white
        reactionContainerViewBottomConstraint = NSLayoutConstraint(item: viewReactionsContainer, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        reactionContainerViewBottomConstraint.isActive = true
        
        let reactionVCConfiguration:ReactionVCConfiguration = ReactionVCConfiguration(emojiTypes: EmojiType.allCases)
        vcReactions.configureViewController(configuration: reactionVCConfiguration , delegate: self)
        self.addChildViewController(childController: vcReactions, onView: viewReactionsContainer)
        
    }
    
   
    func reactionViewControllerEmojiSelected(viewController: ReactionVC, type: EmojiType) {
        addEmojiView(type: type, owner: .me)
    }
    

    private func setUpDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplayLink))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.common)
    }
    
    @objc private func updateDisplayLink() {
        let currentTime = CACurrentMediaTime()*1000
        let seed = Int.random(in: 1..<200)
        guard Int(currentTime) % seed == 0 else { return }
        let type = EmojiType.allCases.randomElement()!
        addEmojiView(type: type, owner: .other)
    }
  

}


/// EMOJI VIEW
extension LiveStreamVC {
    fileprivate func addEmojiView(type:EmojiType , owner:EmojiOwner) {
        let initPos = CGPoint(x: EmojiView.widthConstraintValue/2, y: EmojiView.heightConstraintValue)
        let finalPos = CGPoint(x: initPos.x, y: 0)
        let configuration = EmojiViewConfiguration(owner:owner, oscilation: 120, itemSize: 30, duration: 7, initialPosition: initPos, finalPosition: finalPos, emojiType: type )
        let emojiView = EmojiView(configuration: configuration)
        emojiView.addTo(view: self.viewEmojiContainer)
        // debugPath(path: emojiView.path)
    }
    
    private func debugPath(path:CGPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 1
        self.viewEmojiContainer.layer.addSublayer(shapeLayer)
    }
}


