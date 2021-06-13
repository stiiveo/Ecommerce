//
//  CartItemCell.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/13.
//

import UIKit

class CartItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product) {
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
    }
}
