//
//  ViewController.swift
//  HitsManager
//abc
//  Created by LTT on 11/2/20.
//

import UIKit
import Nuke

class ViewController: UIViewController {
    // MARK: - outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    
    private let viewModel = ViewModel()
    private let sizeOfItem = SizeOfCollectionViewItem()
    private let userView = UserViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.prefetchDataSource = self
        collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "cell")
        
        viewModel.getHitsByPage() { (hits) in
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
}

// Create cell
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.hits.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = initHitCollectionViewCell(indexPath: indexPath)
        return cell
    }
}

// Custom cell
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sizeOfItem.getInsetOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.sellectedCell == indexPath {
            return sizeOfItem.getSizeForDidSellectItem(imageWidth: viewModel.hits[indexPath.row].imageWidth,
                                                       imageHeight: viewModel.hits[indexPath.row].imageHeight)
        }
        
        return sizeOfItem.getSizeForItem()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sizeOfItem.getMinimumInteritemSpacingForSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sizeOfItem.getMinimumLineSpacingForSection()
    }
    
    // Sellect cell
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if viewModel.sellectedCell != indexPath {
            viewModel.sellectedCell = indexPath
        } else {
            viewModel.sellectedCell = IndexPath()
        }
        print(indexPath.row)
        print(viewModel.hits[indexPath.row])
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        viewModel.sellectedCell = IndexPath()
    }
}

// Load next page
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.getHitsInNextPage(indexPaths: indexPaths) { (hits) in
            collectionView.reloadData()
        }
    }
}

// Handle like image
extension ViewController: HitCollectionViewDelegate {
    
    func didLikeImage(hit: Hit) {
        let setDidLikeHitId = Set(DidLikeHit.getListId())
        if !setDidLikeHitId.isSuperset(of: [hit.id]) {
            DidLikeHit.addAnObject(id: hit.id,
                                   url: hit.imageURL,
                                   imageWidth: Float(hit.imageWidth),
                                   imageHeight: Float(hit.imageHeight),
                                   userImageUrl: hit.userImageUrl,
                                   username: hit.username)
        }
    }
    
    func didDisLikeImage(id: Int) {
        DidLikeHit.deleteAnObject(id: id)
    }
    
    func handleLikeButton(cell: HitCollectionViewCell, indexPath: IndexPath) {
        guard let hitId = viewModel.hits[safeIndex: indexPath.row]?.id else { return }
        let listDidLikeImageId = DidLikeHit.getListId()
        if listDidLikeImageId.isSuperset(of: [hitId]) {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

// Display collectionView cell
extension ViewController {
    func initHitCollectionViewCell(indexPath: IndexPath) -> HitCollectionViewCell {
        guard let hit = viewModel.hits[safeIndex: indexPath.row] else { return HitCollectionViewCell()}
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? HitCollectionViewCell else {
            return HitCollectionViewCell()
        }
        cell.delegate = self
        guard let hitId = viewModel.hits[safeIndex: indexPath.row]?.id else { return HitCollectionViewCell() }
        cell.handleLikeButton(indexPath: indexPath, hitId: hitId)
        cell.hit = hit
        cell.setImage()
        return cell
    }
}

// Safe array
extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
