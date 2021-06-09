//
//  Product.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/7.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageURL: String
    var timestamp: Timestamp
    var stock: Int
    
    init(data: [String: Any?]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
}
