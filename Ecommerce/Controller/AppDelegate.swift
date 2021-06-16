//
//  AppDelegate.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/4.
//

import UIKit
import Firebase
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        StripeAPI.defaultPublishableKey = "pk_test_51J1mKIAqLZa7BNSnUTK00VWM7WrffRPxBy6OeMPMK19MmAkX3qHtKWqmUAL4hVXSC4dHJAnFL6Xul2bsHrnWUi1x00MSwej9bd"
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

