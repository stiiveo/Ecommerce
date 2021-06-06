//
//  RoundedViews.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/5.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class RoundedShadow: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = Constants.Color.AppAccent.Blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
    }
}

class RoundImageView: UIImageView {
    
}
