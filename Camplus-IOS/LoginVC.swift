//
//  LoginVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-06.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.layer.cornerRadius = 8
        userName.layer.borderWidth = 0.7
        userName.layer.masksToBounds = true
        
        password.layer.cornerRadius = 8
        password.layer.borderWidth = 0.7
        password.layer.masksToBounds = true
    }

}
