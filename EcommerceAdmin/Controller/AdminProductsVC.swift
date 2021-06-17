//
//  AdminProductsVC.swift
//  EcommerceAdmin
//
//  Created by Jason Ou on 2021/6/10.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let addProductButton  = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(addProduct))
        navigationItem.setRightBarButtonItems([editCategoryButton, addProductButton], animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Clear the selected product after user edited any product and come back to this VC.
        selectedProduct = nil
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @objc func addProduct() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit product.
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.ToAddEditProduct:
            if let destination = segue.destination as? AddEditProductVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        case Segues.ToEditCategory:
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        default:
            debugPrint("Wrong segue identifier was provided.")
            break
        }
    }
    
    override func productFavorited(product: Product) {
        return
    }
    
    override func productAddedToCart(product: Product) {
        return
    }

}
