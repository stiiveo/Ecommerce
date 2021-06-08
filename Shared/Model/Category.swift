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
    var timestamp: Timestamp
    
    init(data: [String: Any?]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
