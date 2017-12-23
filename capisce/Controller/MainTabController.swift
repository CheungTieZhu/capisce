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
    override func viewWillAppear(_ animated: Bool) {
        isItHaveLogin()
    }
    
    private func isItHaveLogin(){
        if (!UserProfileManage.shared.isLoggedIn()){
            showLogin()
        }else{
            if !justLogIn{
                if let userName = UserDefaults.getUsername(),let userToken = UserDefaults.getUserToken(){
                    UserProfileManage.shared.getUserInfo(userName: userName, userToken: userToken, completion: {(msg) in
                        if msg == "success"{

                        }else{
                            self.showLogin()
                        }
                    })
                }
            }else{
                justLogIn = false
            }
        }
    }
    
    func showLogin(){
        if let LoginViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            loginViewController = LoginViewController as? LoginController
            self.present(LoginViewController, animated: true, completion: nil)
        }
    }
}
