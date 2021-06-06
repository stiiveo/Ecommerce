//
//  HomeVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/4.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var logInOutButton: UIBarButtonItem!
    
    // Log in / out state
    var loggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loggedIn {
            logInOutButton.title = Constants.ViewController.Home.Title.logOut
        } else {
            logInOutButton.title = Constants.ViewController.Home.Title.logIn
        }
    }
    
    fileprivate func presentLogInController() {
        let storyboard = UIStoryboard(name: Constants.ViewController.LogIn.StoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: Constants.ViewController.LogIn.Identifier)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

    @IBAction func logInOutButtonClicked(_ sender: UIBarButtonItem) {
        if loggedIn {
            // Sign out the currently logged in user.
            do {
                try Auth.auth().signOut()
                presentLogInController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            presentLogInController()
        }
    }
    
}

