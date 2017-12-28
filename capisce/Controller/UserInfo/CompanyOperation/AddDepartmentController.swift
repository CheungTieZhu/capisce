//
//  AddDepartmentController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/27.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material

class AddDepartmentController: UIViewController{
    
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var departmentTextField: TextField!
    
    @IBOutlet weak var departmentDescription: TextView!
    
    @IBOutlet weak var responsblePerson: TextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var companyDictionary: Company?
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    private func setupTextField(){
        // userName
        departmentTextField.placeholder  = "部门名称"
        let departmentTextFieldLeftView = UIImageView()
        departmentTextFieldLeftView.image = Icon.settings
        departmentTextField.leftView = departmentTextFieldLeftView
        // userName
        departmentDescription.placeholder  = "部门描述"
        // userName
        responsblePerson.placeholder  = "部门负责人"
        let responsblePersonLeftView = UIImageView()
        responsblePersonLeftView.image = Icon.settings
        responsblePerson.leftView = responsblePersonLeftView
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
}
