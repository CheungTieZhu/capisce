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
    
    @IBOutlet weak var countryCodeTextField: TextField!
    
    @IBOutlet weak var phoneTextField: TextField!
    
    @IBOutlet weak var messageTextField: TextField!
    
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBOutlet weak var confirmTextField: TextField!
    
    var countryCode: String = "86"
    
    var phoneNumber: String?
    
    lazy var flagPicker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = #colorLiteral(red: 0.8298732638, green: 0.8780719638, blue: 0.9114663601, alpha: 1)
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        return p
    }()
    
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
        userNameTextField.placeholder  = "用户名"
        let userNameInputLeftView = UIImageView()
        userNameInputLeftView.image = Icon.settings
        userNameTextField.leftView = userNameInputLeftView
        //countryCode
        countryCodeTextField.placeholder  = "区号"
        let phoneTextFieldLeftView = UIImageView()
        phoneTextFieldLeftView.image = Icon.phone
        countryCodeTextField.leftView = phoneTextFieldLeftView
        countryCodeTextField.inputView = flagPicker
        // phone
        phoneTextField.placeholder  = "手机号"
        // message
        messageTextField.placeholder  = "验证码"
        let messageTextFieldLeftView = UIImageView()
        messageTextFieldLeftView.image = Icon.email
        messageTextField.leftView = messageTextFieldLeftView
        // password
        passwordTextField.placeholder  = "密码"
        let passwordTextFieldLeftView = UIImageView()
        passwordTextFieldLeftView.image = Icon.settings
        passwordTextField.leftView = passwordTextFieldLeftView
        // confirm
        confirmTextField.placeholder  = "再次确认"
        let confirmTextFieldLeftView = UIImageView()
        confirmTextFieldLeftView.image = Icon.settings
        confirmTextField.leftView = confirmTextFieldLeftView
        
    }
    
    private func verifyUserNewPhoneNum(){
//        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNumber, zone: countryCode, result: { (err) in
//            if let err = err {
//                print("PhoneNumViewController: lgoin有错误: \(String(describing: err))")
//                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
//                self.displayGlobalAlert(title: "获取验证码失败", message: msg, action: "OK", completion: nil)
//                return
//            }
//        })
    }
    
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        if let phone = phoneTextField.text{
            phoneNumber = phone
            verifyUserNewPhoneNum()
        }else{
            let msg = "请先填写手机号码"
            self.displayGlobalAlert(title: "获取验证码失败", message: msg, action: "OK", completion: nil)
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
//        if let message = messageTextField.text,let phone = phoneNumber{
//            SMSSDK.commitVerificationCode(message, phoneNumber: phone, zone: countryCode, result: { (err) in
//                if err == nil {
                    self.verifySuccess()
//                } else {
//                    self.verifyFaildAlert(err?.localizedDescription)
//                }
//            })
//        }
    }
    
    private func verifySuccess(){
        if let userName = userNameTextField.text,let password = passwordTextField.text,let phone = phoneNumber{
            UserProfileManage.shared.postRegisterUser(userName: userName, password: password, phone: countryCode+phone, completion: { (result, msg) in
                if let success = result,let message = msg{
                    if success == "success"{
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        self.displayGlobalAlert(title: "register failed", message: message, action: "OK", completion: nil)
                    }
                }
            })
        }
    }
    
    private func verifyFaildAlert(_ msg: String?){
        let errMsg = "您的短信验证码有误，请重新获取验证码"
        print("VerificationController++: verifyFaild(): 验证失败，error: \(errMsg)")
        displayGlobalAlert(title: "验证失败", message: errMsg, action: "重发验证码", completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        userNameTextField.resignFirstResponder()
        countryCodeTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        messageTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmTextField.resignFirstResponder()
    }
    
}
extension UserRegisterController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flagsTitle.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return flagsTitle[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCode = codeOfFlag[flagsTitle[row]]!
        countryCodeTextField.text = "+"+countryCode
    }
}
