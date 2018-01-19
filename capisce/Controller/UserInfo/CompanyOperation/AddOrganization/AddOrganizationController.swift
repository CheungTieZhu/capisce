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
    var departmentArray: [String] = []
    
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var departmentNameTextField: TextField!
    
    @IBOutlet weak var personSearchTextField: TextField!
    
    @IBOutlet weak var departmentSelect: TextField!
    
    @IBOutlet weak var departmentDescription: TextView!
    
    @IBOutlet weak var saveButton: Button!
    
    lazy var departmentPicker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = #colorLiteral(red: 0.8298732638, green: 0.8780719638, blue: 0.9114663601, alpha: 1)
        p.dataSource = self
        p.delegate = self
        return p
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let getDepartmentquene = DispatchQueue(label: "getDepartment")
        getDepartmentquene.sync {
            if let company = companyDictionary?.company[index].company{
                CompanyOperationManager.shared.postGetDepartment(company: company, completion: { (result, data) in
                    if result == "success"{
                        self.departmentArray = data
                        self.departmentSelect.inputView = self.departmentPicker
                    }
                })
            }
        }
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
                companyIcon.image = #imageLiteral(resourceName: "capisce_company_default")
            }
            companyName.text = company
        }
        if request == 0{
            departmentNameTextField.placeholder = "部门名称"
            personSearchTextField.placeholder = "部门负责人"
            departmentDescription.placeholder = "部门简介"
            departmentSelect.isHidden = true
        }else{
            departmentNameTextField.placeholder = "小组名称"
            personSearchTextField.placeholder = "小组负责人"
            departmentDescription.placeholder = "小组简介"
            departmentSelect.isHidden = false
            departmentSelect.placeholder = "所属部门"
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let company = companyName.text,let userName = userDictionary?.multipleUser[index].userName,let note = departmentDescription.text,let department = departmentSelect.text,let organizationName = departmentNameTextField.text{
            CompanyOperationManager.shared.postSetupOrganization(company: company, userName: userName, note: note, department: department, organizationName: organizationName, request: request, completion: { (result) in
                if result == "success"{
                    self.displayGlobalAlert(title: "成功", message: "创建成功", action: "OK", completion: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }else{
                    self.displayGlobalAlert(title: "错误", message: "创建失败", action:"OK" , completion: nil)
                }
            })
        }
    }
    
    @IBAction func searchPersonEditDone(_ sender: Any) {
        setupUserDictionary()
    }
    
    
}

extension AddOrganizationController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departmentArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departmentArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        departmentSelect.text = departmentArray[row]
    }
}

