//
//  Extensions.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension UIViewController {
    /// Present alert controller with specified title, message and an action button titled "OK" with no action attached.
    /// - Parameters:
    ///   - title: The alert title.
    ///   - message: The alert message.
    func presentSimpleAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// Present alert to the guest user with sign in/up hint message.
    func presentAlertToGuest() {
        self.presentSimpleAlert(
            withTitle: "Hi friend!",
            message: "This is a user only feature, please sign in or sign up to enjoy all of the features."
        )
    }
}

extension Int {
    /// Convert specified integer to currency format string using built-in number formatter.
    /// The specified integer is expected to in the unit of penny as used by `Stripe` API.
    /// - Returns: The converted integer in currency format.
    func penniesToFormattedCurrency() -> String {
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}
