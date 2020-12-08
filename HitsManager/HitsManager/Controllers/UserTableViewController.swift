//
//  UserTableViewController.swift
//  HitsManager
//
//  Created by LTT on 20/11/2020.
//

import Foundation
import UIKit

class UserTableViewController: UIViewController {
    
    // MARK: - outlet
    @IBOutlet weak var hitTableView: UITableView!
    
    private var didLikeHits: [Hit] = []
    var userViewModel: UserViewModel?
    var didDislikeImagesId: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        didLikeHits = userViewModel?.getDidLikeHit(didLikeHits: DidLikeHit.getListDidLikeHit()) ?? []
        hitTableView.register(UINib.init(nibName: "TableViewCell", bundle: nil),
                              forCellReuseIdentifier: "cell")
        scrollToRow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let newDidLikeHits = userViewModel?.getDidLikeHit(didLikeHits: DidLikeHit.getListDidLikeHit()) ?? []
        let setDidLikeHits = Set(didLikeHits)
        let setNewDidLikeHits = Set(newDidLikeHits)
        if setDidLikeHits != setNewDidLikeHits {
            didLikeHits = newDidLikeHits
            hitTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        for id in didDislikeImagesId {
            DidLikeHit.deleteAnObject(id: id)
        }
    }
}

// Create cell
extension UserTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return didLikeHits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = initHittableViewCell(indexPath: indexPath)
        return cell
    }
}

// Display cell
extension UserTableViewController {
    func initHittableViewCell(indexPath: IndexPath) -> HitTableViewCell {
        guard userViewModel != nil else {
            return HitTableViewCell()
        }
        guard let cell = hitTableView.dequeueReusableCell(withIdentifier: "cell") as? HitTableViewCell else {
            return HitTableViewCell()
        }
        guard let hit = didLikeHits[safeIndex: indexPath.row] else {return HitTableViewCell()}
        cell.hit = hit
        cell.setHeightOfHitImageView(imageWidth: CGFloat(hit.imageWidth),
                                     imageHeight: CGFloat(hit.imageHeight))
        cell.delegate = self
        cell.handleLikeButton(hit: hit, didDislikeImagesId: didDislikeImagesId)
        
        // user imageview
        cell.setImageForUserView()
        
        // hit imageview
        cell.setImageForHitImageView()
        return cell
    }
}

extension UserTableViewController {
    func scrollToRow(){
        DispatchQueue.main.async {
            guard self.userViewModel != nil else { return }
            if self.userViewModel!.isDisplayCellAtChosenIndexPath {
                self.hitTableView.scrollToRow(at: self.userViewModel!.chosenIndexPath,
                                              at: .top,
                                              animated: false)
                self.userViewModel!.isDisplayCellAtChosenIndexPath = false
            }
        }
    }
}

extension UserTableViewController: UserTableViewCellDelegate {
    func didLikeImage(id: Int) {
        didDislikeImagesId.remove(id)
    }
    
    func didDisLikeImage(id: Int) {
        didDislikeImagesId.insert(id)
    }
}
