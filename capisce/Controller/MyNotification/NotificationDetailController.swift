//
//  NotificationDetailController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/29.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material
import AlamofireImage

class NotificationDetailController: UIViewController{
    
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var UserName: UILabel!
    
    @IBOutlet weak var requestLabel: UILabel!
    
    @IBOutlet weak var noteDetail: UILabel!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var rejectButton: UIButton!
    
    @IBOutlet weak var ignoreButton: UIButton!
    
    var index :Int = 0
    
    var notificationDictionary: NotificationList?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBasicInfomation()
        setupButtonStatus()
    }
    
    private func setupButtonStatus(){
        if let userName = notificationDictionary?.notification[index].userName,let current = UserProfileManage.shared.getCurrentUser(),let currUserName = current.userName,let action = notificationDictionary?.notification[index].accept{
            if userName != currUserName{
                agreeButton.isEnabled = false
                rejectButton.isEnabled = false
            }
            if action < 2{
                agreeButton.isEnabled = true
                rejectButton.isEnabled = true
            }else{
                agreeButton.isEnabled = false
                rejectButton.isEnabled = false
            }
        }
    }
    
    private func setupBasicInfomation(){
        if let companyIconString = notificationDictionary?.notification[index].companyIcon,let imgUrl = URL(string:companyIconString){
            companyIcon.af_setImage(withURL: imgUrl)
        }
        if let company = notificationDictionary?.notification[index].company{
            companyName.text = company
        }
        if let realName = notificationDictionary?.notification[index].realName{
            UserName.text = realName
        }
        if let request = notificationDictionary?.notification[index].request{
            switch request{
            case 0:
                requestLabel.text = requestStatus.addMember.rawValue
            case 1:
                requestLabel.text = requestStatus.kickOut.rawValue
            default:
                requestLabel.text = requestStatus.addMember.rawValue
            }
        }
        if let note = notificationDictionary?.notification[index].note{
            noteDetail.text = note
        }
    }
   

    @IBAction func AgreeButtonTapped(_ sender: Any) {
        if let id = notificationDictionary?.notification[index].id{
            NotificationManage.shared.postUserGlobalAction(id: id, accept: 2, senderAccept: 2, completion: { (result) in
                if result == "success"{
                    self.displayGlobalAlert(title: "成功", message: "发送成功", action: "OK", completion: nil)
                }else{
                    self.displayGlobalAlert(title: "失败", message: "失败", action: "OK", completion: nil)
                }
            })
        }
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        if let id = notificationDictionary?.notification[index].id{
            NotificationManage.shared.postUserGlobalAction(id: id, accept: 3, senderAccept: 3, completion: { (result) in
                if result == "success"{
                    self.displayGlobalAlert(title: "成功", message: "发送成功", action: "OK", completion: nil)
                }else{
                    self.displayGlobalAlert(title: "失败", message: "失败", action: "OK", completion: nil)
                }
            })
        }
    }
    
    @IBAction func ignoreButtonTapped(_ sender: Any) {
        if let id = notificationDictionary?.notification[index].id,let userName = notificationDictionary?.notification[index].userName,let currentUser = UserProfileManage.shared.getCurrentUser(),let currUserName = currentUser.userName{
            if userName == currUserName{
                NotificationManage.shared.postUserLocalAction(id: id, accept: 4, completion: { (result) in
                    if result == "success"{
                        self.displayGlobalAlert(title: "成功", message: "发送成功", action: "OK", completion: nil)
                    }else{
                        self.displayGlobalAlert(title: "失败", message: "失败", action: "OK", completion: nil)
                    }
                })
            }else{
                NotificationManage.shared.postSenderIgnore(id: id, senderAccept: 4, completion: { (result) in
                    if result == "success"{
                        self.displayGlobalAlert(title: "成功", message: "发送成功", action: "OK", completion: nil)
                    }else{
                        self.displayGlobalAlert(title: "失败", message: "失败", action: "OK", completion: nil)
                    }
                })
            }
        }
    }
}
