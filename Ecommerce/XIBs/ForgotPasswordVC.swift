//
//  ForgotPasswordVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/6.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.alpha = 0.5
    }


    @IBAction func resetButtonClicked(_ sender: UIButton) {
        guard let email = emailTextField.text,
              email.isNotEmpty else {
            debugPrint("Email value is empty.")
            presentSimpleAlert(withTitle: "Error", message: "Please provide your email.")
            return
        }
        
        Auth.auth().useAppLanguage()
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Fail to send password reset.
                debugPrint(error)
                Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
            } else {
                // Reset password email has been sent.
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
