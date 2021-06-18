//
//  LoginVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInClicked(_ sender: UIButton) {
        guard let email = emailText.text,
              let password = passwordText.text else {
            debugPrint("Failed to retrieve text from the text field(s).")
            return
        }
        
        guard email.isNotEmpty, password.isNotEmpty else {
            presentSimpleAlert(withTitle: "Error", message: "Email and password are required.")
            debugPrint("User did not provide email and/or password.")
            return
        }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                // Unable to sign in with provided credential infos.
                debugPrint(error)
                Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
                self.activityIndicator.stopAnimating()
                return
            }
            // User is successfully signed in.
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func logInAsGuestClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordClicked(_ sender: UIButton) {
        let forgotPasswordVC = ForgotPasswordVC()
        forgotPasswordVC.modalPresentationStyle = .overCurrentContext
        forgotPasswordVC.modalTransitionStyle = .crossDissolve
        present(forgotPasswordVC, animated: true, completion: nil)
    }
    
}
