//
//  AddMemberController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/27.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit

class AddMemberController: UIViewController{
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var searchUser: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var companyDictionary: Company?
    
    var index: Int = 0
    
    var realNameDisplay: String?
    
    var userInfoDictionary: MultipleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        setupCompanyLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupCompanyLabel(){
        if let companyName = companyDictionary?.company[index].company{
            companyNameLabel.text = companyName
        }
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.searchUser.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        searchUser.resignFirstResponder()
    }
    
    @IBAction func searchUserEndEdit(_ sender: Any) {
        if let realName = searchUser.text{
            realNameDisplay = realName
            UserProfileManage.shared.postOtherUserInfo(realName: realName, completion: { (result) in
                if result == "success"{
                    if let multipleUser = UserProfileManage.shared.getMultipleUser(){
                        self.userInfoDictionary = multipleUser
                        if let childVC = self.childViewControllers.first as? SearchUserTable {
                            childVC.userDisplayTable.reloadData()
                        }
                    }
                }else{
                    self.displayGlobalAlert(title: "错误", message: "错误", action: "OK", completion: nil)
                }
            })
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
    }
}
