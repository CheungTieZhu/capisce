//
//  UserInfoController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/22.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material

class UserInfoController: UIViewController {
    @IBOutlet weak var userHeadImgButton: Button!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var logOutButton: Button!
    @IBOutlet weak var companySelected: UICollectionView!
    
    var companyIndex:Int = 0
    var companyDict: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInformation()
        setupCompanyDict()
    }
    
    private func setupCompanyDict(){
        if let dictionary = CompanyManage.shared.getCurrentCompany(){
            companyDict = dictionary
            self.companySelected.reloadData()
        }
    }
    
    private func setupInformation(){
        if let userInfo = UserProfileManage.shared.getCurrentUser(){
            if let realName = userInfo.realName{
                greetingLabel.text = "hello!"+realName
            }
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        if let userName = UserDefaults.getUsername(){
            UserProfileManage.shared.getLogOutUser(userName: userName, completion: { (result, msg) in
                if result == "success"{
                    UserDefaults.removeUsername()
                    UserDefaults.removeUserToken()
                    AppDelegate.shared().mainTabViewController?.showLogin()
                }
            })
        }
    }
}
extension UserInfoController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let number = companyDict?.company.count{
            return number
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = companySelected.dequeueReusableCell(withReuseIdentifier: "companyButtonCellId", for: indexPath) as! CompanyButtonCell
        cell.buttonLabel.text = companyDict?.company[indexPath.row].company
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        companyIndex = indexPath.item
        if let childVC = self.childViewControllers.first as? UserOperationController {
            childVC.userOperationTable.reloadData()
        }
    }
}

