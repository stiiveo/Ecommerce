//
//  Constants.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit

struct Constants {
    
    struct ViewController {
        struct Home {
            struct Title {
                static let logIn = "LogIn"
                static let logOut = "LogOut"
            }
        }
        struct LogIn {
            static let StoryboardName = "LoginStoryBoard"
            static let Identifier = "loginVC"
        }
    }
    
    struct Color {
        struct AppAccent {
            static let White = #colorLiteral(red: 0.9626371264, green: 0.959995091, blue: 0.9751287103, alpha: 1)
            static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
            static let Blue = #colorLiteral(red: 0.2914361954, green: 0.3395442367, blue: 0.4364506006, alpha: 1)
        }
    }
    
}