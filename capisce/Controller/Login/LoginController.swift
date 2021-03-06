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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTextField(){
        userNameInput.placeholder  = "用户名"
        passwordInput.placeholder = "密码"
        let userNameInputLeftView = UIImageView()
        userNameInputLeftView.image = Icon.settings
        let passwordInputLeftView = UIImageView()
        passwordInputLeftView.image = Icon.settings
        userNameInput.leftView = userNameInputLeftView
        passwordInput.leftView = passwordInputLeftView
    }
    
    
    @IBAction func LogInButtonTapped(_ sender: Any) {
        if let userName = userNameInput.text,let password = passwordInput.text {
            UserProfileManage.shared.postLoginUser(userName: userName, password: password) { (msg) in
                if msg == "success" {
                    self.getCompanyInformation()
                }else{
                    print("login failed")
                }
            }
        }
    }
    
    private func getCompanyInformation(){
        if let userName = UserDefaults.getUsername(),let userToken = UserDefaults.getUserToken(){
            CompanyManage.shared.getCompanyInfo(userName: userName, userToken: userToken, completion: { (msg) in
                if msg == "success"{
                    justLogIn = true
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print("login failed")
                }
            })
        }
    }
    
    
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userNameInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
}
