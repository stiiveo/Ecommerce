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
    
    @objc func editCategory() {
        performSegue(withIdentifier: Constants.Segues.ToEditCategory, sender: self)
    }
    
    @objc func addProduct() {
        performSegue(withIdentifier: Constants.Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit product.
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Constants.Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segues.ToAddEditProduct:
            if let destination = segue.destination as? AddEditProductVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        case Constants.Segues.ToEditCategory:
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        default:
            debugPrint("Wrong segue identifier was provided.")
            break
        }
    }

}
