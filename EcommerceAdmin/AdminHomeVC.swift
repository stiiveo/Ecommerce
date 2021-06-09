//
//  AdminHomeVC.swift
//  EcommerceAdmin
//
//  Created by Jason Ou on 2021/6/4.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let addCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryButton
    }

    @objc func addCategory() {
        // Segue to 'Add Category' view
    }

}

