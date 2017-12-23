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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInformation()
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
