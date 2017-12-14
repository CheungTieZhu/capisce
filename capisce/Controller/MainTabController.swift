//
//  MainTabController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/14.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController{
    var loginViewController: LoginController?
    override func viewDidLoad() {
        isItHaveLogin()
    }
    
    private func isItHaveLogin(){
        showLogin()
    }
    
    private func showLogin(){
        if let LoginViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            loginViewController = LoginViewController as? LoginController
            self.present(LoginViewController, animated: true, completion: nil)
        }
    }
}
