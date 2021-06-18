//
//  AddEditProductVC.swift
//  EcommerceAdmin
//
//  Created by Jason Ou on 2021/6/10.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

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
    var productToUpload: Product!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateFieldsWithSelectedProduct()
        attachTapGRToImageView()
    }
    
    func populateFieldsWithSelectedProduct() {
        if let product = productToEdit {
            // Populate UI with selected product's data.
            nameTextField.text = product.name
            priceTextField.text = String(product.price)
            imageHintLabel.text = "Tap to change product image"
            descriptionTextView.text = product.productDescription
            actionButton.setTitle("Save Changes", for: .normal)
            if let imageUrl = URL(string: product.imageURL) {
                imageView.contentMode = .scaleAspectFill
                imageView.kf.setImage(with: imageUrl)
            }
        }
    }
    
    func attachTapGRToImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        indicator.startAnimating()
        validateInputThenUpload()
    }
    
    func validateInputThenUpload() {
        // Validate data provided by the user.
        guard let name = nameTextField.text, name.isNotEmpty,
              let priceText = priceTextField.text, let price = Double(priceText),
              let image = imageView.image,
              let description = descriptionTextView.text, description.isNotEmpty else {
            presentSimpleAlert(withTitle: "Error", message: "Please fill out all information.")
            debugPrint("User did not provide needed info.")
            indicator.stopAnimating()
            return
        }
        
        // Convert image into jpeg data.
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            presentSimpleAlert(withTitle: "Error", message: "Unable to convert image data.")
            debugPrint("Failed to convert image to jpeg data.")
            indicator.stopAnimating()
            return
        }
        
        productToUpload = Product(name: name, id: "", category: selectedCategory.id, price: price, description: description, imageURL: "", stock: 1)
        
        uploadImageDataThenDocument(imageData: imageData)
    }
    
    func uploadImageDataThenDocument(imageData: Data) {
        // Create an image reference to Firebase Storage.
        let imageRef = Storage.storage().reference().child("productImages/\(productToUpload.name).jpg")
        
        // Set file metadata.
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload image data.
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                self.handleError(error: error!, message: "Unable to upload data to server.")
                return
            }
            // Retrieve the download URL once the image is uploaded.
            imageRef.downloadURL { url, error in
                guard error == nil else {
                    self.handleError(error: error!, message: "Unable to retrieve image url.")
                    return
                }
                guard let url = url else {
                    debugPrint("Failed to retrieve valid image url.")
                    return
                }
                
                // Upload new Category document to the FireStore categories collection.
                self.productToUpload.imageURL = url.absoluteString
                self.uploadDocument()
            }
        }
    }
    
    func uploadDocument() {
        // Initialize document reference and product objects.
        var docRef: DocumentReference!
        
        if let productToEdit = productToEdit {
            // Assign the product the original document ID.
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            productToUpload.id = productToEdit.id
        } else {
            // Assign the product a new document ID generated by Firestore.
            docRef = Firestore.firestore().collection("products").document()
            let newDocumentID = docRef.documentID
            productToUpload.id = newDocumentID
        }
        
        // Write data to specified document.
        let data = Product.modelToData(product: productToUpload)
        docRef.setData(data, merge: true) { error in
            guard error == nil else {
                self.handleError(error: error!, message: "Unable to upload data to the server.")
                return
            }
            // Document is uploaded successfully.
            self.indicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func handleError(error: Error, message: String) {
        presentSimpleAlert(withTitle: "Error", message: message)
        debugPrint(error.localizedDescription)
        indicator.stopAnimating()
    }
    
}

extension AddEditProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        imageView.contentMode = .scaleAspectFill
        imageView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
}
