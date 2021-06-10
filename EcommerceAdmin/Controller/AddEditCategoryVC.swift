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

    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var categoryToEdit: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
    }

    @IBAction func addCategoryClicked(_ sender: Any) {
        indicator.startAnimating()
        uploadImageThenDocument()
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    func uploadImageThenDocument() {
        // Make sure the user had provided valid name and image.
        guard let image = categoryImage.image,
              let name = categoryName.text, name.isNotEmpty else {
            presentAlert(withTitle: "Error", message: "Category name and image are required.")
            debugPrint("User did not provide category image or name.")
            self.indicator.stopAnimating()
            return
        }
        // Convert the image to jpeg data.
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            presentAlert(withTitle: "Error", message: "Sorry, something went wrong.")
            self.indicator.stopAnimating()
            return
        }
        // Create an image reference in the firebase storage.
        let imageRef = Storage.storage().reference().child("categoryImages/\(name).jpg")
        
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
                guard let url = url else { return }
                print(url)
                
                // Upload new Category document to the FireStore categories collection.
                self.uploadDocument(url: url.absoluteString)
                self.indicator.stopAnimating()
            }
        }
    }
    
    func uploadDocument(url: String) {
        // Initialize document reference and category objects.
        var docRef: DocumentReference!
        var category = Category(name: categoryName.text!, id: "", imageURL: url, timestamp: Timestamp())
        
        docRef = Firestore.firestore().collection("categories").document()
        category.id = docRef.documentID
        
        // Add the document using the data converted from the Category object to Cloud FireStore.
        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { error in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload image to the server.")
                return
            }
            // Once the uploading is complete, dismiss the current top VC.
            self.navigationController?.popViewController(animated: true)
            self.indicator.stopAnimating()
        }
    }
    
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.presentAlert(withTitle: "Error", message: message)
        self.indicator.stopAnimating()
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
