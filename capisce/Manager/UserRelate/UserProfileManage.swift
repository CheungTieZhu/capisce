//
//  UserProfileManage.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/21.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

class UserProfileManage: NSObject{
    static let shared = UserProfileManage()
    private var currentUser: User?
    func postLoginUser(userName: String? = nil,
                       password: String,
                       completion: @escaping (User?, String?) -> Void) { //(token, username), error
        
        //        let deviceToken = UserDefaults.getDeviceToken() ?? ""
        
        let route = "/user/login"
        
        var parameter:[String: Any] = [
            ServerKey.password.rawValue: password
        ]
        if let userName = userName {
            parameter [ServerKey.userName.rawValue] = userName
        }
        
        Apiservers.shared.getDataWithUrlRoute(route,parameters: parameter){ (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let msg = response[ServerKey.message.rawValue] as? String{
                if msg == "success"{
                    if let data = response[ServerKey.data.rawValue] as? [String: Any]{
                        do{
                            let profileInfo: User = try unbox(dictionary: data)
                            self.currentUser = profileInfo
                            self.currentUser?.printAllData()
                            completion(profileInfo,msg)
                        }catch{
                            print("unbox failed")
                            completion(nil,msg)
                        }
                    }else{
                        completion(nil,msg)
                    }
                }else{
                    completion(nil,msg)
                    print("user Log in fail")
                }
            }else{
                completion(nil,"failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
    
    func updateUserProfile(_ profileInfo: User, writeToKeychain: Bool){
        
    }
}
