//
//  LoginController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/14.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material

class LoginController: UIViewController {
    
    @IBOutlet weak var userNameInput: TextField!
    
    @IBOutlet weak var passwordInput: TextField!
    
    @IBOutlet weak var loginButton: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTextField(){
        userNameInput.placeholder  = "User name"
        passwordInput.placeholder = "Password"
        userNameInput.detailLabel.text = "User name"
        passwordInput.detailLabel.text = "Password"
        let userNameInputLeftView = UIImageView()
        userNameInputLeftView.image = Icon.settings
        let passwordInputLeftView = UIImageView()
        passwordInputLeftView.image = Icon.settings
        userNameInput.leftView = userNameInputLeftView
        passwordInput.leftView = passwordInputLeftView
    }
    
    
    @IBAction func LogInButtonTapped(_ sender: Any) {
        if let userName = userNameInput.text,let password = passwordInput.text {
            Apiservers.shared.postLoginUser(userName: userName, password: password) { (msg, err) in
                if err == nil {
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print(err)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userNameInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
}
