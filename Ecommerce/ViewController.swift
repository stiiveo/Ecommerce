//
//  ViewController.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/4.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "loginVC")
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }

}

