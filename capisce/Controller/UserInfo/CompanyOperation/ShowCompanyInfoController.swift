//
//  ShowCompanyInfoController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/27.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit

class ShowCompanyInfoController: UIViewController{
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companyIconImage: UIImageView!
    
    var companyDictionary: Company?
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCompanyInfo()
    }
    
    private func setupNavigationBar(){
        title = "公司详情"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    private func getCompanyInfo(){
        if let company = companyDictionary?.company[index].company{
            CompanyOperationManager.shared.getCompanyInfo(company: company, completion: { (result) in
                if result == "success"{
                    self.setUpCompanyInfo()
                }else{
                    self.displayGlobalAlert(title: "错误", message: "获取信息错误", action: "ok", completion: nil)
                }
            })
        }
    }
    
    private func setUpCompanyInfo(){
        if let companyInfo = CompanyOperationManager.shared.getCurrentCompany(),let company = companyDictionary?.company[index].company{
            if let childVC = self.childViewControllers.first as? CompanyDetailTable {
                childVC.companyBusinessLabel.text = companyInfo.business
                childVC.companyManagerLabel.text = companyInfo.ownerName
                childVC.companyDescriptionLabel.text = companyInfo.description
                if let number = companyInfo.employeeNumber{
                    childVC.employeeNumberLabel.text = String(number)
                }
                companyNameLabel.text = company
            }
        }
    }
}
