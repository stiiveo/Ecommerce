//
//  CartItemCell.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/13.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    weak var delegate: CartItemCellDelegate?
    private var product: Product!
    
    func configureCell(product: Product, delegate: CartItemCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        titleLabel.text = product.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            priceLabel.text = price
        }
        
        
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
        
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(product: product)
    }
}
