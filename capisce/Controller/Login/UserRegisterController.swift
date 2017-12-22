//
//  UserRegisterController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/21.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material

class UserRegisterController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: TextField!
    
    @IBOutlet weak var phoneTextField: TextField!
    
    @IBOutlet weak var messageTextField: TextField!
    
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBOutlet weak var confirmTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupTextField(){
        // userName
        userNameTextField.placeholder  = "User name"
        let userNameInputLeftView = UIImageView()
        userNameInputLeftView.image = Icon.settings
        userNameTextField.leftView = userNameInputLeftView
        // phone
        phoneTextField.placeholder  = "Phone Number"
        let phoneTextFieldLeftView = UIImageView()
        phoneTextFieldLeftView.image = Icon.phone
        phoneTextField.leftView = phoneTextFieldLeftView
        // message
        messageTextField.placeholder  = "Message"
        let messageTextFieldLeftView = UIImageView()
        messageTextFieldLeftView.image = Icon.email
        messageTextField.leftView = messageTextFieldLeftView
        // password
        passwordTextField.placeholder  = "Password"
        let passwordTextFieldLeftView = UIImageView()
        passwordTextFieldLeftView.image = Icon.settings
        passwordTextField.leftView = passwordTextFieldLeftView
        // confirm
        confirmTextField.placeholder  = "Confirm"
        let confirmTextFieldLeftView = UIImageView()
        confirmTextFieldLeftView.image = Icon.settings
        confirmTextField.leftView = confirmTextFieldLeftView
        
    }
    
    private func verifyUserNewPhoneNum(phone: String){
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phone, zone: "1", result: { (err) in
            if let err = err {
                print("PhoneNumViewController: lgoin有错误: \(String(describing: err))")
//                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
//                self.displayGlobalAlert(title: "获取验证码失败", message: msg, action: "OK", completion: nil)
                return
            }
        })
    }
    
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        if let phone = phoneTextField.text{
            verifyUserNewPhoneNum(phone: phone)
        }else{
            
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userNameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        messageTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmTextField.resignFirstResponder()
    }
    
}
