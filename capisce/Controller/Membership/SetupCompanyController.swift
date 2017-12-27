//
//  SetupCompanyController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/25.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material

class SetupCompanyController: UIViewController {
    
    @IBOutlet weak var companyIconButton: Button!
    
    @IBOutlet weak var companyNameTextField: TextField!
    
    @IBOutlet weak var companyBusinessTextField: UITextField!
    
    @IBOutlet weak var companyDescription: TextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    private func setupTextField(){
        //公司名称
        companyNameTextField.placeholder  = "公司名称"
        let userNameInputLeftView = UIImageView()
        userNameInputLeftView.image = Icon.settings
        companyNameTextField.leftView = userNameInputLeftView
        //公司业务
        companyBusinessTextField.placeholder  = "公司业务"
        let phoneTextFieldLeftView = UIImageView()
        phoneTextFieldLeftView.image = Icon.phone
        companyBusinessTextField.leftView = phoneTextFieldLeftView
        //公司简介
        companyDescription.placeholder = "公司简介"
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let currentUser = UserProfileManage.shared.getCurrentUser(){
            if let userName = currentUser.userName,let company = companyNameTextField.text,let business = companyBusinessTextField.text,let description = companyDescription.text{
                CompanyManage.shared.createCompany(userName: userName, company: company, business: business, description: description, companyIcon: "0", completion: { (result, msg) in
                    if result == "success"{
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        self.displayGlobalAlert(title: "错误", message: msg!, action: "Ok", completion: nil)
                    }
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        companyNameTextField.resignFirstResponder()
        companyBusinessTextField.resignFirstResponder()
        companyDescription.resignFirstResponder()
    }
}
