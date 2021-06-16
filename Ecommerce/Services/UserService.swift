//
//  UserService.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService() // Access point to this class.

final class _UserService {
    
    // Variables
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener: ListenerRegistration? = nil
    var favsListener: ListenerRegistration? = nil
    
    var isGuest: Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        }
        return false
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ userSnap, error in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            
            guard let userData = userSnap?.data() else {
                debugPrint("Failed to retrieve valid user data from firestore.")
                return
            }
            
            self.user = User(data: userData)
        })
        
        getUserFavorites(userRef: userRef)
    }
    
    func getUserFavorites(userRef: DocumentReference) {
        let favsRef = userRef.collection("favorites")
        favsListener = favsRef.addSnapshotListener({ favsSnap, error in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }
            
            favsSnap?.documentChanges.forEach({ change in
                let data = change.document.data()
                let favorite = Product(data: data)
                self.favorites.append(favorite)
            })
        })
    }
    
    func favoriteSelected(product: Product) {
        let favsRef = Firestore.firestore().collection("users").document(user.id)
            .collection("favorites")
        if favorites.contains(product) {
            // Un-favorite the product.
            favorites.removeAll { $0 == product }
            favsRef.document(product.id).delete()
        } else {
            // Favorite the product
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = User()
        favorites.removeAll()
        StripeCart.cartItems.removeAll()
    }
    
}
