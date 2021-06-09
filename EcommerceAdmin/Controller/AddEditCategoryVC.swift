//
//  AddEditCategoryVC.swift
//  EcommerceAdmin
//
//  Created by Jason Ou on 2021/6/9.
//

import UIKit

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
    }

    @IBAction func addCategoryClicked(_ sender: Any) {
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
}

extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        categoryImage.contentMode = .scaleAspectFill
        categoryImage.image = pickedImage
        categoryImage.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
