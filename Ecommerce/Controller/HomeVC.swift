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
        
//        fetchDocument()
        fetchCollection()
    }
    
    func fetchDocument() {
        let docReference = db.collection("categories").document("v3QdKR5fTQE7ayjoo8Iu")
        docReference.getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            let newCategory = Category(data: data)
            self.categories.append(newCategory)
            self.collectionView.reloadData()
        }
    }
    
    func fetchCollection() {
        let collectionReference = db.collectionGroup("categories")
        collectionReference.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                let newCategory = Category(data: document.data())
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLogButtonTitle()
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
        let cellWidth = (viewWidth - 30) / 2
        let cellHeight = cellWidth * 1.2
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
