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
    
    var userIsAnonymous: Bool {
        if let user = Auth.auth().currentUser {
            return user.isAnonymous
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    debugPrint(error)
                    self.handleFIRAuthError(error: error)
                }
                self.updateLogButtonTitle()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLogButtonTitle()
    }
    
    fileprivate func presentLogInController() {
        let storyboard = UIStoryboard(name: Constants.ViewController.LogIn.StoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: Constants.ViewController.LogIn.Identifier)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

    @IBAction func logInOutButtonClicked(_ sender: UIBarButtonItem) {
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLogInController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { result, error in
                    if let error = error {
                        debugPrint(error)
                        self.handleFIRAuthError(error: error)
                    }
                    self.presentLogInController()
                }
            } catch {
                debugPrint(error)
                handleFIRAuthError(error: error)
            }
        }
    }
    
    fileprivate func updateLogButtonTitle() {
        if userIsAnonymous {
            logInOutButton.title = Constants.ViewController.Home.Title.logIn
        } else {
            logInOutButton.title = Constants.ViewController.Home.Title.logOut
        }
    }
    
}

