//
//  ReactionVCEmojiCell.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 29.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class ReactionVCEmojiCell: UICollectionViewCell {
    
    @IBOutlet weak var imViewEmoji: UIImageView!
    @IBOutlet weak var viewLatestSelected: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewLatestSelected.layer.cornerRadius = viewLatestSelected.frame.size.width/2
        viewLatestSelected.layer.masksToBounds = true
        viewLatestSelected.isHidden = true
    }
    
    func updateCell(emojiImage:UIImage , isLatestSelected:Bool) {
        viewLatestSelected.isHidden = !isLatestSelected
        imViewEmoji.image = emojiImage
    }

}

extension ReactionVCEmojiCell {
    static func size()->CGSize {
        return CGSize(width: 55, height: 55)
    }
}
