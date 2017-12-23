//
//  UserDefaults++.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/14.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation

let usernameKey = "capisce.user-default.key.username"
let deviceTokenKey = "capisce.user-default.key.device-token"
let userTokenKey = "capisce.user-default.key.userToken"

extension UserDefaults {
    
    //Username
    static func setUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: usernameKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: usernameKey)
    }
    
    static func removeUsername() {
        UserDefaults.standard.removeObject(forKey: usernameKey)
    }
    
    //Device Token
    static func getDeviceToken() -> String? {
        return UserDefaults.standard.string(forKey: deviceTokenKey)
    }
    
    static func setDeviceToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: deviceTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    //UserToken
    static func setUserToken(_ userToken: String) {
        UserDefaults.standard.set(userToken, forKey: userTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: userTokenKey)
    }
    
    static func removeUserToken() {
        UserDefaults.standard.removeObject(forKey: userTokenKey)
    }
}

