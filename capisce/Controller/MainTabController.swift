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
    var myInfoCtl: UserInfoController?
    override func viewWillAppear(_ animated: Bool) {
        isItHaveLogin()
        if let viewControllers = self.viewControllers as? [UINavigationController] {
            for navigationController in viewControllers {
                if let myInfoContoller = navigationController.childViewControllers[0] as? UserInfoController {
                    myInfoCtl = myInfoContoller
                }
            }
        }
    }
    
    private func isItHaveLogin(){
        if (!UserProfileManage.shared.isLoggedIn()){
            showLogin()
        }else{
            if !justLogIn{
                if let userName = UserDefaults.getUsername(),let userToken = UserDefaults.getUserToken(){
                    UserProfileManage.shared.getUserInfo(userName: userName, userToken: userToken, completion: {(msg) in
                        if msg == "success"{
                            self.getCompanyInfo(userName: userName, userToken: userToken)
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
    private func getCompanyInfo(userName: String,userToken: String){
        CompanyManage.shared.getCompanyInfo(userName: userName, userToken: userToken, completion: { (msg) in
            if msg == "success"{
                print("get user information successed")
            }else{
                print("get Company information failed")
            }
        })
    }
    
    func showLogin(){
        if let LoginViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            loginViewController = LoginViewController as? LoginController
            self.present(LoginViewController, animated: true, completion: nil)
        }
    }
}
