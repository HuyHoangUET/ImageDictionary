//
//  CollectionViewCell.swift
//  HitsManager
//
//  Created by LTT on 11/2/20.
//

import Foundation
import UIKit
import Nuke

class HitCollectionViewCell: UICollectionViewCell {
    // MARK: - outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: HitCollectionViewDelegate?
    var hit = Hit()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    func setImage() {
        guard hit.imageURL != "" else { return }
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "placeholder")
            )
        Nuke.loadImage(with: URL(string: hit.imageURL)!, options: options, into: imageView)
    }
    
    func handleLikeButton(indexPath: IndexPath, hitId: Int) {
        let listDidLikeImageId = DidLikeHit.getListId()
        if listDidLikeImageId.isSuperset(of: [hitId]) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    // MARK: - action
    @IBAction func likeButton(_ sender: UIButton) {
        let heartImage = UIImage(systemName: "heart.fill")
        if sender.currentImage == heartImage {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            delegate?.didDisLikeImage(id: hit.id)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            delegate?.didLikeImage(hit: hit)
            
        }
    }
}
