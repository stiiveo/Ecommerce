//
//  ForgotPasswordVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/6.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.alpha = 0.6
        dialogView.layer.cornerRadius = 5
        titleLabel.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }


    @IBAction func resetButtonClicked(_ sender: UIButton) {
        // send reset password command to FIR API...
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
