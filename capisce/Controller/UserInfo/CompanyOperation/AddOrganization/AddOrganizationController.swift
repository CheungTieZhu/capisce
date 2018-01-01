//
//  AddOrganizationController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/30.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material
import AlamofireImage

class AddOrganizationController: UIViewController{
    var companyDictionary: Company?
    var index: Int = 0
    var request :Int = 0
    var userDictionary: MultipleUser?
    var realNameDisplay: String?
    
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var departmentNameTextField: TextField!
    
    @IBOutlet weak var personSearchTextField: TextField!
    
    
    @IBOutlet weak var departmentDescription: TextView!
    
    @IBOutlet weak var saveButton: Button!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewDisplay()
        addDoneButtonOnKeyboard()
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.departmentNameTextField.inputAccessoryView = doneToolbar
        self.personSearchTextField.inputAccessoryView = doneToolbar
        self.departmentDescription.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        departmentNameTextField.resignFirstResponder()
        personSearchTextField.resignFirstResponder()
        departmentDescription.resignFirstResponder()
    }
    
    private func setupUserDictionary(){
        if let company = companyDictionary?.company[index].company,let realName = personSearchTextField.text{
            CompanyOperationManager.shared.postSearchPerson(realName: realName, company: company, completion: { (result) in
                if result == "success" {
                    if let multipleUser = CompanyOperationManager.shared.getMultipleUser(){
                        self.userDictionary = multipleUser
                        self.realNameDisplay = self.personSearchTextField.text
                    }
                    if let childVC = self.childViewControllers.first as? SearchPersonTable{
                        childVC.searchPersonTable.reloadData()
                    }
                }else{
                    self.displayGlobalAlert(title: "错误", message: "获取失败", action: "OK", completion: nil)
                }
            })
        }
    }
    
    private func setupViewDisplay(){
        if let company = companyDictionary?.company[index].company{
            companyIcon.layer.masksToBounds = true
            companyIcon.layer.cornerRadius = CGFloat(Float(companyIcon.frame.width)/2)
            if let companyIconString = companyDictionary?.company[index].companyIcon,let imgUrl = URL(string:companyIconString){
                companyIcon.af_setImage(withURL: imgUrl)
            }else{
                companyIcon.image = #imageLiteral(resourceName: "capisce_company")
            }
            companyName.text = company
        }
        if request == 0{
            departmentNameTextField.placeholder = "部门名称"
            personSearchTextField.placeholder = "部门负责人"
            departmentDescription.placeholder = "部门简介"
        }else{
            departmentNameTextField.placeholder = "小组名称"
            personSearchTextField.placeholder = "小组负责人"
            departmentDescription.placeholder = "小组简介"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func searchPersonEditDone(_ sender: Any) {
        setupUserDictionary()
    }
    
    
}
