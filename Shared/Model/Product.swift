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
    
    init(name: String,
         id: String,
         category: String,
         price: Double,
         description: String,
         imageURL: String,
         timestamp: Timestamp = Timestamp(),
         stock: Int) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = description
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.stock = stock
    }
    
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
    
    static func modelToData(product: Product) -> [String: Any] {
        let data: [String: Any] = [
            "name": product.name,
            "id": product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDescription,
            "imageURL": product.imageURL,
            "timestamp": product.timestamp,
            "stock": product.stock,
        ]
        return data
    }
}

extension Product: Equatable {
    /// Compares and returns if the specified`Product` object on the left hand side
    /// is equal to the one on the right hand side.
    /// - Parameters:
    ///   - lhs: `Product` on the left hand side of the equation.
    ///   - rhs: `Product` on the right hand side of the equation.
    /// - Returns: Returns true if the 2 specified `Product`s are the same.
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
