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
    
    var userIsAnonymous: Bool {
        if let user = Auth.auth().currentUser {
            return user.isAnonymous
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let category = Category(name: "Computer", id: "01", imageURL: "https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80", timeStamp: Timestamp())
        categories.append(category)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.Identifiers.categoryCell, bundle: nil), forCellWithReuseIdentifier: Constants.Identifiers.categoryCell)
        
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.categoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        let cellWidth = (viewWidth - 30) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
