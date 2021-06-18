//
//  AddEditCategoryVC.swift
//  EcommerceAdmin
//
//  Created by Jason Ou on 2021/6/9.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: RoundedButton!
    
    var categoryToEdit: Category?
    var categoryToUpload: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        if let category = categoryToEdit {
            // Populate the UI with data if editing is in progress.
            nameTextField.text = category.name
            hintLabel.text = "Tap image to change category image"
            actionButton.setTitle("Save Changes", for: .normal)
            
            if let imageUrl = URL(string: category.imageURL) {
                imageView.contentMode = .scaleAspectFill
                imageView.kf.setImage(with: imageUrl)
            }
        }
    }

    @IBAction func buttonClicked(_ sender: Any) {
        indicator.startAnimating()
        validateInputThenUpload()
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    func validateInputThenUpload() {
        // Make sure the user had provided valid name and image.
        guard let image = imageView.image,
              let name = nameTextField.text, name.isNotEmpty else {
            presentSimpleAlert(withTitle: "Error", message: "Category name and image are required.")
            debugPrint("User did not provide category image or name.")
            self.indicator.stopAnimating()
            return
        }
        // Convert the image to jpeg data.
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            presentSimpleAlert(withTitle: "Error", message: "Unable to convert image data.")
            self.indicator.stopAnimating()
            return
        }
        
        categoryToUpload = Category(name: name, id: "", imageURL: "")
        uploadImageThenDocument(imageData: imageData)
    }
    
    func uploadImageThenDocument(imageData: Data) {
        // Create an image reference to the firebase storage.
        let imageRef = Storage.storage().reference().child("categoryImages/\(categoryToUpload.name).jpg")
        
        // Set the metadata
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // Upload the data.
        imageRef.putData(imageData, metadata: metaData) { metaData, error in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload image to the server.")
                return
            }
            // Retrieve the download URL once the image is uploaded.
            imageRef.downloadURL { url, error in
                if let error = error {
                    self.handleError(error: error, message: "Unable to retrieve image url.")
                    return
                }
                guard let url = url else {
                    debugPrint("Failed to retrieve valid image url.")
                    return
                }
                self.categoryToUpload.imageURL = url.absoluteString
                
                // Upload new Category document to the FireStore categories collection.
                self.uploadDocument()
            }
        }
    }
    
    func uploadDocument() {
        // Initialize document reference and category objects.
        var docRef: DocumentReference!
        
        if let categoryToEdit = categoryToEdit {
            // Edit existing category with user-edited data.
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            categoryToUpload.id = categoryToEdit.id
        } else {
            // Get a new document with an auto-generated document ID.
            docRef = Firestore.firestore().collection("categories").document()
            categoryToUpload.id = docRef.documentID
        }
        
        // Add the document using the data converted from the Category object to Cloud FireStore.
        let data = Category.modelToData(category: categoryToUpload)
        docRef.setData(data, merge: true) { error in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload data to the server.")
                return
            }
            // Document is uploaded successfully.
            self.navigationController?.popViewController(animated: true)
            self.indicator.stopAnimating()
        }
    }
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        presentSimpleAlert(withTitle: "Error", message: message)
        indicator.stopAnimating()
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
        imageView.contentMode = .scaleAspectFill
        imageView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
