//
//  ProductDetailVC.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/9.
//

import UIKit

class ProductDetailVC: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle.text = product.name
        productDescription.text = product.productDescription
        
        if let imageURL = URL(string: product.imageURL) {
            productImage.kf.setImage(with: imageURL)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cartClicked(_ sender: Any) {
        // Add product to cart
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
