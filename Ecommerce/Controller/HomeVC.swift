//
//  HomeVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/4.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var logInOutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    var userIsAnonymous: Bool {
        if let user = Auth.auth().currentUser {
            return user.isAnonymous
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Constants.Identifiers.CategoryCell)
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    // Failed to sign in the current user anonymously.
                    debugPrint(error)
                    Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
                }
                self.updateLogButtonTitle()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLogButtonTitle()
        setCategoriesListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener.remove()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove loaded data so when this VC appears again, same data won't appear twice.
        categories.removeAll()
        collectionView.reloadData()
    }
    
    func setCategoriesListener() {
        listener = db.collection("categories").addSnapshotListener({ snapshot, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            // Process each document change depending on its type.
            snapshot?.documentChanges.forEach({ change in
                let data = change.document.data()
                let category = Category(data: data)
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified()
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified() {
        
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    fileprivate func presentLogInController() {
        let storyboard = UIStoryboard(name: Constants.ViewController.LogIn.StoryboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: Constants.ViewController.LogIn.Identifier)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

    @IBAction func logInOutButtonClicked(_ sender: UIBarButtonItem) {
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLogInController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { result, error in
                    if let error = error {
                        // Failed to sign in anonymously.
                        debugPrint(error)
                        Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
                    }
                    self.presentLogInController()
                }
            } catch {
                // Failed to sign out the current user.
                debugPrint(error)
                Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
            }
        }
    }
    
    fileprivate func updateLogButtonTitle() {
        if userIsAnonymous {
            logInOutButton.title = Constants.ViewController.Home.Title.logIn
        } else {
            logInOutButton.title = Constants.ViewController.Home.Title.logOut
        }
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        let cellWidth = (viewWidth - 10) / 2
        let cellHeight = cellWidth * 1.25
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Constants.Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.Segues.ToProducts else { return }
        if let destination = segue.destination as? ProductsVC {
            destination.selectedCategory = selectedCategory
        }
    }
    
}

// Reference

//    func fetchDocument() {
//        let docReference = db.collection("categories").document("v3QdKR5fTQE7ayjoo8Iu")
//
//        docReference.addSnapshotListener { snapshot, error in
//            self.categories.removeAll()
//            guard let data = snapshot?.data() else { return }
//            let newCategory = Category(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }

//        docReference.getDocument { snapshot, error in
//            guard let data = snapshot?.data() else { return }
//            let newCategory = Category(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//    }

//    func fetchCollection() {
//        let collectionReference = db.collectionGroup("categories")
//
//        listener = collectionReference.addSnapshotListener { snapshot, error in
//            guard let documents = snapshot?.documents else { return }
//            self.categories.removeAll()
//            for document in documents {
//                let newCategory = Category(data: document.data())
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }

//        collectionReference.getDocuments { snapshot, error in
//            guard let documents = snapshot?.documents else { return }
//            for document in documents {
//                let newCategory = Category(data: document.data())
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
//    }
