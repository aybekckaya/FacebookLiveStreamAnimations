//
//  ReactionVCCommentCell.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 29.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class ReactionVCCommentCell: UICollectionViewCell , UITextViewDelegate {

    @IBOutlet weak var lblContainerView: UIView!
    @IBOutlet weak var twComment: UITextView!
    
    private let placeholderColor:UIColor = UIColor.lightGray
    private let textColor:UIColor = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblContainerView.layer.cornerRadius = self.lblContainerView.frame.size.height / 2
        self.lblContainerView.layer.masksToBounds = true
        self.lblContainerView.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        self.lblContainerView.layer.borderWidth = 1
        twComment.delegate = self 
    }

    func updateCell(text:String , placeholderText:String) {
      
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension ReactionVCCommentCell {
    static func size()->CGSize {
        return CGSize(width: 300, height: 55)
    }
}
