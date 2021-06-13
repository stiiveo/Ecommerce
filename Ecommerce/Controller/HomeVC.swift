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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setUpCollectionView()
        setUpInitialAnonymousUser()
    }
    
    func setUpCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    func setUpInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    // Failed to sign in the current user anonymously.
                    Auth.auth().presentFIRAuthErrorAlert(error: error, toViewController: self)
                    debugPrint(error)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addCategoriesListener()
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            // User is signed in.
            logInOutButton.title = BarButtonText.logOut
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            // User is signed out.
            logInOutButton.title = BarButtonText.logIn
        }
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
    
    func addCategoriesListener() {
        listener = db.categories.addSnapshotListener({ snapshot, error in
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
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    fileprivate func presentLogInController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LogInVC)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
    @IBAction func logInOutButtonClicked(_ sender: UIBarButtonItem) {
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLogInController()
        } else {
            // Sign out the logged–in user and sign in anonymously.
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
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
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            // Item changed, but remained in the same position.
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            // Item changed and changed its position.
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0),
                                    to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        let cellWidth = (viewWidth - 10) / 2
        let cellHeight = cellWidth * 1.3
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Segues.ToProducts:
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        case Segues.ToFavorites:
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        default:
            break
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
