//
//  StripeCart.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/13.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    // Variables for subtotal, processing, total
    
    var subtotal: Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees: Int {
        if subtotal == 0 {
            return 0
        }
        
        let subtotal = Double(subtotal)
        let feesAndSubtotal = Int(subtotal * stripeCreditCardCut) + flatFeeCents
        return feesAndSubtotal
    }
    
    var total: Int {
        return subtotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
}
