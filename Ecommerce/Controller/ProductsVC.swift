//
//  ProductsVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/7.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        let product = Product(name: "Dell XPS 13", id: "dell_xps_13", category: "Computer", price: 999.99, productDescription: "Dell XPS 13", imageURL: "https://images.unsplash.com/photo-1567521463850-4939134bcd4a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=967&q=80", timeStamp: Timestamp(), stock: 1, favorite: false)
        products.append(product)
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: Constants.Identifiers.ProductCell)
    }

}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.ProductCell, for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
