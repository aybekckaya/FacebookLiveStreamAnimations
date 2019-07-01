//
//  ReactionVC.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 27.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

struct ReactionVCConfiguration {
    let arrEmojiTypes:[EmojiType]
    init(emojiTypes:[EmojiType]) {
        self.arrEmojiTypes = emojiTypes
    }
}

protocol ReactionVCDelegate {
    func reactionViewControllerEmojiSelected(viewController:ReactionVC , type:EmojiType)
}


class ReactionVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
   
    private enum ReactionVCCollectionCellType {
        case commentCell
        case emojiCell(emojiType:EmojiType)
    }
    
    @IBOutlet weak var collectionViewItems: UICollectionView!
    
    private var arrCellTypes:[ReactionVCCollectionCellType] = []
    private let placeholder:String = "Write a comment..."
    private var latestSelectedEmojiType:EmojiType? = nil
    private var delegate:ReactionVCDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        let nibCommentCell = UINib(nibName: "ReactionVCCommentCell", bundle: nil)
        let nibEmojiCell = UINib(nibName: "ReactionVCEmojiCell", bundle: nil)
        self.collectionViewItems.register(nibCommentCell, forCellWithReuseIdentifier: "ReactionVCCommentCell")
        self.collectionViewItems.register(nibEmojiCell, forCellWithReuseIdentifier: "ReactionVCEmojiCell")
        self.collectionViewItems.delegate = self
        self.collectionViewItems.dataSource = self
        self.collectionViewItems.showsHorizontalScrollIndicator = false
        if let layout = collectionViewItems.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.collectionViewItems.reloadData()
    }
    
    func configureViewController(configuration:ReactionVCConfiguration , delegate:ReactionVCDelegate) {
        self.delegate = delegate
        self.arrCellTypes.append(ReactionVCCollectionCellType.commentCell)
        configuration.arrEmojiTypes.forEach { typeEmoji in
            self.arrCellTypes.append(ReactionVCCollectionCellType.emojiCell(emojiType: typeEmoji))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellType:ReactionVCCollectionCellType = arrCellTypes[indexPath.row]
        if case ReactionVCCollectionCellType.emojiCell( _) = cellType {
            return ReactionVCEmojiCell.size()
        }
        else if case ReactionVCCollectionCellType.commentCell = cellType {
           return ReactionVCCommentCell.size()
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType:ReactionVCCollectionCellType = arrCellTypes[indexPath.row]
        if case ReactionVCCollectionCellType.emojiCell(let emojiType) = cellType {
            let cell:ReactionVCEmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReactionVCEmojiCell", for: indexPath) as! ReactionVCEmojiCell
            cell.updateCell(emojiImage: emojiType.image, isLatestSelected: emojiType == latestSelectedEmojiType )
            return cell
        }
        else if case ReactionVCCollectionCellType.commentCell = cellType {
            let cell:ReactionVCCommentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReactionVCCommentCell", for: indexPath) as! ReactionVCCommentCell
            cell.updateCell(text: "", placeholderText: placeholder)
            return cell
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        let currentSelectedType = arrCellTypes[indexPath.row]
        if case ReactionVCCollectionCellType.commentCell = currentSelectedType {
            
        }
        else if case ReactionVCCollectionCellType.emojiCell(let emojiType) = currentSelectedType {
            self.latestSelectedEmojiType = emojiType
            self.collectionViewItems.reloadData()
            delegate.reactionViewControllerEmojiSelected(viewController: self, type: emojiType)
        }
    }

}
