//
//  LoginVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func logInClicked(_ sender: UIButton) {
        guard let email = emailText.text,
              let password = passwordText.text else { return }
        
        // Make sure the input is not empty
        guard email.isNotEmpty && password.isNotEmpty else { return }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                // auth failed...
                print("Log in failed: \(error!)")
                self.activityIndicator.stopAnimating()
                return
            }
            // auth success...
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func logInAsGuestClicked(_ sender: UIButton) {
        print("logInAsGuestClicked")
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        print("forgotPasswordClicked")
    }
    
}
