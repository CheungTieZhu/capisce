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
    private var multipleUser: MultipleUser?
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func getMultipleUser() -> MultipleUser? {
        return multipleUser
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.getUsername() != nil
    }
    
    func postLoginUser(userName: String? = nil,
                       password: String,
                       completion: @escaping (String?) -> Void) { //(token, username), error
        let route = "/user/login"
        var parameter:[String: Any] = [
            ServerKey.password.rawValue: password
        ]
        if let userName = userName {
            parameter [ServerKey.userName.rawValue] = userName
        }
        
        Apiservers.shared.postDataWithUrlRoute(route,parameters: parameter){ (response, error) in
            
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
                            if let username = self.currentUser?.userName,let userToken = self.currentUser?.userToken{
                                UserDefaults.setUsername(username)
                                UserDefaults.setUserToken(userToken)
                            }
                            completion(msg)
                        }catch{
                            print("unbox failed")
                            completion(msg)
                        }
                    }else{
                        completion(msg)
                    }
                }else{
                    completion(msg)
                    print("user Log in fail")
                }
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
    func postRegisterUser(userName: String,
                          password: String,
                          phone: String,
                          registerStatus: String,
                          completion: @escaping (String?, String?) -> Void){
        let deviceToken = UserDefaults.getDeviceToken() ?? ""
        let route = "/user/register"
        let parameters:[String: Any] = [
            ServerKey.userName.rawValue: userName,
            ServerKey.password.rawValue: password,
            ServerKey.phone.rawValue: phone,
            ServerKey.deviceToken.rawValue: deviceToken,
            ServerKey.registerStatus.rawValue: registerStatus
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters){(response, error) in
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let result = response[ServerKey.result.rawValue] as? String,let msg = response[ServerKey.message.rawValue] as? String{
                        completion(result,msg)
                }else{
                    completion(nil,"failed")
                    print("user Log in fail")
                }
        }
    }
    func getLogOutUser(userName: String,completion: @escaping (String?, String?) -> Void){
        let route = "/user/logOut"
        let parameters:[String: Any] = [
            ServerKey.userName.rawValue: userName
        ]
        Apiservers.shared.getDataWithUrlRoute(route, parameters: parameters){(response, error) in
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let result = response[ServerKey.result.rawValue] as? String,let msg = response[ServerKey.message.rawValue] as? String{
                completion(result,msg)
            }else{
                completion(nil,"failed")
                print("user Log in fail")
            }
        }
    }
    func getUserInfo(userName: String,userToken: String,completion: @escaping (String?) -> Void){
        let route = "/user/getInfo"
        let parameters:[String: Any] = [
            ServerKey.userName.rawValue: userName,
            ServerKey.userToken.rawValue: userToken
        ]
        Apiservers.shared.getDataWithUrlRoute(route, parameters: parameters){(response, error) in
            
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
                            completion(msg)
                        }catch{
                            print("unbox failed")
                            completion(msg)
                        }
                    }else{
                        completion(msg)
                    }
                }else{
                    completion(msg)
                    print("user Log in fail")
                }
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
    
    func postOtherUserInfo(realName: String,userName: String,completion: @escaping (String?) -> Void){
        let route = "/user/getOther"
        let parameters:[String: Any] = [
            ServerKey.realName.rawValue: realName,
            ServerKey.userName.rawValue: userName
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
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
                            let userInfo: MultipleUser = try unbox(dictionary: data)
                            self.multipleUser = userInfo
                            completion(msg)
                        }catch{
                            print("unbox failed")
                            completion(msg)
                        }
                    }else{
                        completion(msg)
                    }
                }else{
                    completion(msg)
                    print("user Log in fail")
                }
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
}
