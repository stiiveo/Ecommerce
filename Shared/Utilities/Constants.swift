//
//  Constants.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit

struct BarButtonText {
    static let logIn = "Sign In"
    static let logOut = "Sign Out"
}

struct StoryboardID {
    static let LogInVC = "LogInVC"
}

struct Storyboard {
    static let LoginStoryBoard = "LoginStoryBoard"
}

struct Color {
    struct AppAccent {
        static let White = #colorLiteral(red: 0.9626371264, green: 0.959995091, blue: 0.9751287103, alpha: 1)
        static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
        static let Blue = #colorLiteral(red: 0.2914361954, green: 0.3395442367, blue: 0.4364506006, alpha: 1)
    }
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
}
