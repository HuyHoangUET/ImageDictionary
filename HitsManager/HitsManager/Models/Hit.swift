//
//  Hit.swift
//  HitsManager
//
//  Created by LTT on 11/2/20.
//

import Foundation
import UIKit

struct Hit: Decodable, Hashable {
    var id: Int
    var imageURL: String
    var imageWidth: CGFloat
    var imageHeight: CGFloat
    var userImageUrl: String
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageURL = "largeImageURL"
        case imageWidth = "imageWidth"
        case imageHeight = "imageHeight"
        case userImageUrl = "userImageURL"
        case username = "user"
    }
    
    init(id: Int, imageUrl: String, imageWidth: CGFloat, imageHeight: CGFloat, userImageUrl: String, username: String) {
        self.id = id
        self.imageURL = imageUrl
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.userImageUrl = userImageUrl
        self.username = username
    }
    
    init() {
        id = 0
        imageURL = ""
        imageWidth = 0
        imageHeight = 0
        userImageUrl = ""
        username = ""
    }
}
