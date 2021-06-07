//
//  Category.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/7.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imageURL: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
