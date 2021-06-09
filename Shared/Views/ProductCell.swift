//
//  ProductCell.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/7.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product) {
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
        productTitle.text = product.name
        productPrice.text = String(product.price)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        print("addToCartClicked")
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        print("favoriteClicked")
    }
    
}
