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
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authResult, error in
            guard error == nil else {
                // auth failed...
                return
            }
            // auth success...
        }
    }
    
    @IBAction func logInAsGuestClicked(_ sender: UIButton) {
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
    }
    
}
