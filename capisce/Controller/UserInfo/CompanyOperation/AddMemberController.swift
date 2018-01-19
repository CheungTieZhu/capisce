//
//  AddMemberController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/27.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material

class AddMemberController: UIViewController{
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var searchUser: TextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var noteTextView: TextView!
    
    var companyDictionary: Company?
    
    var index: Int = 0
    
    var realNameDisplay: String?
    
    var userInfoDictionary: MultipleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        setupCompanyLabel()
        setupTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupTextField(){
        searchUser.placeholder  = "用户名称"
        noteTextView.placeholder  = "备注"
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
        self.noteTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        searchUser.resignFirstResponder()
        noteTextView.resignFirstResponder()
    }
    
    @IBAction func searchUserEndEdit(_ sender: Any) {
        if let realName = searchUser.text,let currentUser = UserProfileManage.shared.getCurrentUser(),let userName = currentUser.userName{
            realNameDisplay = realName
            UserProfileManage.shared.postOtherUserInfo(realName: realName,userName: userName,completion: { (result) in
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
        if let childVC = self.childViewControllers.first as? SearchUserTable,let userIndex = childVC.index,let currentUser = UserProfileManage.shared.getCurrentUser(),let company = companyDictionary?.company[index].company,let senderUserName = currentUser.userName,let companyIcon = companyDictionary?.company[index].companyIcon,let note = noteTextView.text{
            if let userName = userInfoDictionary?.multipleUser[userIndex].userName,let userHeadImage = userInfoDictionary?.multipleUser[userIndex].headImageUrl{
                NotificationManage.shared.postSendNotification(company: company, userName: userName, senderUserName: senderUserName, accept: 0,senderAccept: 1, request: 0, userHeadImage: userHeadImage, companyIcon: companyIcon,note: note,completion: { (result) in
                    if result == "success"{
                        self.displayGlobalAlert(title: "成功", message: "已成功发送请求", action: "OK", completion: nil)
                    }else{
                        self.displayGlobalAlert(title: "错误", message: "错误", action: "OK", completion: nil)
                    }
                })
            }
        }
    }
}
