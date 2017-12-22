//
//  User.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/21.
//  Copyright © 2017年 capisce. All rights reserved.
//
import Foundation
import Unbox

enum ProfileUserKey: String {
    case userName    = "userName"
    case realName    = "realName"
    case id          = "id"
    case phone       = "phone"
    case loginTime   = "loginTime"
    case logOutTime  = "logOutTime"
    case deviceToken = "deviceToken"
    case userToken   = "userToken"
}

class User: Unboxable  {
    
    var id: Int?
    var userName: String?
    var realName: String?
    var phone: String?
    var loginTime: String?
    var logOutTime: String?
    var deviceToken: String?
    var userToken: String?
    init() {
        //Initialization
    }
    
    func printAllData(){
        let allData = """
        id = \(id ?? 0)
        userName = \(userName ?? "")
        realName = \(realName ?? "")
        phone = \(phone ?? "")
        loginTime = \(loginTime ?? "")
        logOutTime = \(logOutTime ?? "")
        deviceToken = \(deviceToken ?? "")
        userToken = \(userToken ?? ""),
        """
        print(allData)
    }
    
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: ProfileUserKey.id.rawValue)
        self.userName = try? unboxer.unbox(key: ProfileUserKey.userName.rawValue)
        self.realName = try? unboxer.unbox(key: ProfileUserKey.realName.rawValue)
        self.phone = try? unboxer.unbox(key: ProfileUserKey.phone.rawValue)
        self.loginTime = try? unboxer.unbox(key: ProfileUserKey.loginTime.rawValue)
        self.logOutTime = try? unboxer.unbox(key: ProfileUserKey.logOutTime.rawValue)
        self.deviceToken = try? unboxer.unbox(key: ProfileUserKey.deviceToken.rawValue)
        self.userToken = try? unboxer.unbox(key: ProfileUserKey.userToken.rawValue)
    }
}
