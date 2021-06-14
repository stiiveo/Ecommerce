//
//  ProductCell.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/7.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: AnyObject {
    func productFavorited(product: Product)
    func productAddedToCart(product: Product)
}

class ProductCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: ProductCellDelegate?
    private var product: Product!
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        // Configure UI components.
        productTitle.text = product.name
        
        if let url = URL(string: product.imageURL) {
            let placeHolder = #imageLiteral(resourceName: "placeholder")
            productImage.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [.transition(.fade(0.1))]
            productImage.kf.setImage(with: url, placeholder: placeHolder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if UserService.favorites.contains(product) {
            favoriteButton.setImage(#imageLiteral(resourceName: "filled_star"), for: .normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "empty_star"), for: .normal)
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        delegate?.productAddedToCart(product: product)
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
    
}
