//
//  UserTableViewCellDelegate.swift
//  HitsManager
//
//  Created by LTT on 27/11/2020.
//

import Foundation
import UIKit

protocol UserTableViewCellDelegate: class {
    func didLikeImage(id: Int)
    func didDisLikeImage(id: Int)
}
