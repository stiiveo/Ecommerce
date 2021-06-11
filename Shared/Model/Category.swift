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
    
    init(name: String,
         id: String,
         imageURL: String,
         isActive: Bool = true,
         timestamp: Timestamp = Timestamp()) {
        self.name = name
        self.id = id
        self.imageURL = imageURL
        self.isActive = isActive
        self.timestamp = timestamp 
    }
    
    init(data: [String: Any?]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(category: Category) -> [String: Any] {
        let data: [String: Any] = [
            "name": category.name,
            "id": category.id,
            "imageURL": category.imageURL,
            "isActive": category.isActive,
            "timestamp": category.timestamp
        ]
        return data
    }
}
