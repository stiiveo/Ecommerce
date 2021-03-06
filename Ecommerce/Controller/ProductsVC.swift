//
//  ProductsVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/7.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController, ProductCellDelegate {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var db: Firestore!
    var category: Category!
    var listener: ListenerRegistration!
    var products = [Product]()
    var showFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        setUpQuery()
    }
    
    func setUpQuery() {
        var ref: Query!
        if showFavorites {
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
        } else {
            ref = db.products(category: category.id)
        }
        
        listener = ref.addSnapshotListener({ snapshot, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            // Snapshot listener is successfully added.
            snapshot?.documentChanges.forEach({ change in
                let data = change.document.data()
                let product = Product(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentModified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    func productFavorited(product: Product) {
        if UserService.isGuest {
            presentAlertToGuest()
            return
        }
        UserService.favoriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func productAddedToCart(product: Product) {
        if UserService.isGuest {
            presentAlertToGuest()
            return
        }
        StripeCart.addItemToCart(item: product)
    }

    @IBAction func cartButtonClicked(_ sender: Any) {
        if UserService.isGuest {
            presentAlertToGuest()
            return
        }
        performSegue(withIdentifier: Segues.ProductsToCheckout, sender: self)
    }
    
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }
    
    func onDocumentModified(change: DocumentChange, product: Product) {
        let oldIndex = Int(change.oldIndex)
        let newIndex = Int(change.newIndex)
        
        if newIndex == oldIndex {
            // Item changed, but remained in the same position.
            products[oldIndex] = product
            tableView.reloadRows(at: [IndexPath(row: oldIndex, section: 0)], with: .automatic)
        } else {
            // Item changed and changed its position.
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0),
                              to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let index = Int(change.oldIndex)
        products.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
