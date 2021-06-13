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
    @IBOutlet weak var removeItemButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
    }
}
