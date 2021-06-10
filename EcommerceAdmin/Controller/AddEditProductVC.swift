//
//  AddEditProductVC.swift
//  EcommerceAdmin
//
//  Created by Jason Ou on 2021/6/10.
//

import UIKit

class AddEditProductVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageHintLabel: UILabel!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: RoundedButton!
    
    var selectedCategory: Category!
    var productToEdit: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonClicked(_ sender: Any) {
    }
    
}
