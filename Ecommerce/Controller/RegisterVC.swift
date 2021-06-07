//
//  RegisterVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordCheckImage: UIImageView!
    @IBOutlet weak var confirmPasswordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.addTarget(self, action: #selector(passwordFieldDidChange), for: UIControl.Event.editingChanged)
        confirmPasswordText.addTarget(self, action: #selector(confirmPasswordFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func passwordFieldDidChange(_ textField: UITextField) {
        // Validate the password and make the check image turn green if so.
        if let password = passwordText.text {
            switch password.count {
            case 0:
                passwordCheckImage.isHidden = true
                confirmPasswordImage.isHidden = true
                confirmPasswordText.text = ""
            case 1..<6:
                passwordCheckImage.isHidden = false
                passwordCheckImage.tintColor = .systemRed
            case 6...:
                passwordCheckImage.isHidden = false
                passwordCheckImage.tintColor = .systemGreen
            default:
                return
            }
        }
    }
    
    @objc func confirmPasswordFieldDidChange(_ textField: UITextField) {
        // Ensure the confirm password matches the password and make the check image turn green if so.
        if let password = passwordText.text,
           let confirmPassword = confirmPasswordText.text {
            if password == confirmPassword {
                if password.isNotEmpty && confirmPassword.isNotEmpty {
                    confirmPasswordImage.isHidden = false
                    confirmPasswordImage.tintColor = .systemGreen
                } else {
                    confirmPasswordImage.isHidden = true
                }
            } else {
                confirmPasswordImage.isHidden = false
                confirmPasswordImage.tintColor = .systemRed
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        // Do validations of the input the user provided here...
        guard let userName = userNameText.text, userName.isNotEmpty,
              let email = emailText.text, email.isNotEmpty,
              let password = passwordText.text, password.isNotEmpty,
              let confirmedPassword = confirmPasswordText.text, confirmedPassword.isNotEmpty else {
            presentAlert(withTitle: "Error", message: "Please fill out all fields.")
            debugPrint("One or more fields are empty.")
            return
        }
        
        // Make sure both values in the password fields are identical.
        guard password == confirmedPassword else {
            presentAlert(withTitle: "Error", message: "Passwords do not match.")
            debugPrint("User–provided password and confirm password does not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        // Associate the current anonymous user's User UID with user–provided info.
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        currentUser.link(with: credential) { authDataResult, error in
            if let error = error {
                // Failed to link provided credential with the current user.
                debugPrint(error)
                Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
                self.activityIndicator.stopAnimating()
                return
            }
            // Linking process is successful.
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
