//
//  TableViewCell.swift
//  HitsManager
//
//  Created by LTT on 20/11/2020.
//

import Foundation
import UIKit
import Nuke

class HitTableViewCell: UITableViewCell {
    
    // MARK: - outlet
    @IBOutlet weak var userInforView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var hitImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heightOfHitImageView: NSLayoutConstraint!
    
    weak var delegate: UserTableViewCellDelegate?
    private let scale = UIImage.SymbolConfiguration(scale: .large)
    var hit = Hit()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hitImageView.image = nil
        userImageView.image = nil
        usernameLabel.text = ""
        likeButton.setImage(nil, for: .normal)
    }
    
    func setBoundsToUserImage() {
        userImageView.layer.cornerRadius = userImageView.frame.height / 2.0
        userImageView.layer.masksToBounds = true
    }
    
    func setHeightOfHitImageView(imageWidth: CGFloat, imageHeight: CGFloat) {
        let ratio = imageHeight / imageWidth
        let widthOfHitImageView = hitImageView.frame.width
        let heightOfHitImageView = widthOfHitImageView * ratio
        self.heightOfHitImageView.constant = heightOfHitImageView;
    }
    
    func setImageForHitImageView() {
        let options = ImageLoadingOptions(
            placeholder: UIImage(named: "placeholder")
            )
        guard hit.imageURL != "" else { return }
        Nuke.loadImage(with: URL(string: hit.imageURL)!, options: options, into: hitImageView)
    }
    
    func setImageForUserView() {
        usernameLabel.text = hit.username
        setBoundsToUserImage()
        let options = ImageLoadingOptions(
            placeholder: UIImage(systemName: "person.circle")
            )
        guard hit.userImageUrl != "" else {
            userImageView.image = UIImage(systemName: "person.circle")
            return
        }
        let request = ImageRequest(url: URL(string: hit.userImageUrl)!,
                                   processors: [ImageProcessors.Circle()])
        Nuke.loadImage(with: request, options: options, into: userImageView)
    }
    
    func handleLikeButton(hit: Hit, didDislikeImagesId: Set<Int>) {
        if didDislikeImagesId.isSuperset(of: [hit.id]){
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: scale), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: scale), for: .normal)
        }
    }
    // MARK: - action
    @IBAction func likeButton(_ sender: Any) {
        let heartImage = UIImage(systemName: "heart", withConfiguration: scale)
        if likeButton.currentImage != heartImage {
            likeButton.setImage(heartImage, for: .normal)
            likeButton.tintColor = .black
            delegate?.didDisLikeImage(id: hit.id)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: scale), for: .normal)
            likeButton.tintColor = .red
            delegate?.didLikeImage(id: hit.id)
        }
    }
}
