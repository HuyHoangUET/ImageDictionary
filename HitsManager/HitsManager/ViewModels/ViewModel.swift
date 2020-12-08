//
//  ViewModel.swift
//  HitsManager
//
//  Created by LTT on 11/6/20.
//

import Foundation
import UIKit
import RealmSwift

class ViewModel {
    weak var delegate: HitCollectionViewDelegate?
    let dataManager = DataManager()
    var hits: [Hit] = []
    var sellectedCell = IndexPath()
    var curentPage = 1
    
    // Get data from api
    func getHitsByPage(completion: @escaping ([Hit]) -> ()) {
        let url = apiURL + "&page=\(curentPage)"
        dataManager.get(url: url) {[weak self] data in
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                self?.hits += result.hits
                completion(self?.hits ?? [])
            } catch {
                print("get hits failed!")
            }
        }
    }
    
    func getHitsInNextPage(indexPaths: [IndexPath], completion: @escaping ([Hit]) -> ()) {
        if indexPaths.last?.row == hits.count - 1 {
            curentPage += 1
            getHitsByPage() { (hits) in
                completion(self.hits)
            }
        }
    }
}
