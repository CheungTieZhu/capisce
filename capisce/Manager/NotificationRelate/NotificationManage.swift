//
//  NotificationManage.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

class NotificationManage: NSObject{
    static let shared = NotificationManage()
    private var Notification: NotificationList?
    
    func getNotification() -> NotificationList? {
        return Notification
    }
    
    func postSendNotification(company: String,userName: String,senderUserName: String,accept: Int,senderAccept: Int,request: Int,userHeadImage: String,companyIcon: String,note: String,completion: @escaping (String?) -> Void){
        let route = "/notification/send"
        let parameters:[String: Any] = [
            NotificationInfoKey.company.rawValue: company,
            NotificationInfoKey.userName.rawValue: userName,
            NotificationInfoKey.senderUserName.rawValue: senderUserName,
            NotificationInfoKey.accept.rawValue: accept,
            NotificationInfoKey.request.rawValue: request,
            NotificationInfoKey.userHeadImage.rawValue: userHeadImage,
            NotificationInfoKey.companyIcon.rawValue: companyIcon,
            NotificationInfoKey.note.rawValue: note,
            NotificationInfoKey.senderAccept.rawValue: senderAccept
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let msg = response[ServerKey.message.rawValue] as? String{
                completion(msg)
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
    
    func postGetNotification(userName: String,completion: @escaping (String?) -> Void){
        let route = "/notification/get"
        let parameters:[String: Any] = [
            NotificationInfoKey.userName.rawValue: userName
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters){(response, error) in
            
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
                            let notificationInfo: NotificationList = try unbox(dictionary: data)
                            self.Notification = notificationInfo
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
    func postUserLocalAction(id: Int,accept: Int,completion: @escaping (String?) -> Void){
        let route = "/notification/userLocalAction"
        let parameters:[String: Any] = [
            NotificationInfoKey.id.rawValue: id,
            NotificationInfoKey.accept.rawValue: accept
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let msg = response[ServerKey.message.rawValue] as? String{
                completion(msg)
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
    func postUserGlobalAction(id: Int,accept: Int,senderAccept: Int,completion: @escaping (String?) -> Void){
        let route = "/notification/userGlobalAction"
        let parameters:[String: Any] = [
            NotificationInfoKey.id.rawValue: id,
            NotificationInfoKey.accept.rawValue: accept,
            NotificationInfoKey.senderAccept.rawValue: senderAccept
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let msg = response[ServerKey.message.rawValue] as? String{
                completion(msg)
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
    func postSenderIgnore(id: Int,senderAccept: Int,completion: @escaping (String?) -> Void){
        let route = "/notification/senderIgnore"
        let parameters:[String: Any] = [
            NotificationInfoKey.id.rawValue: id,
            NotificationInfoKey.senderAccept.rawValue: senderAccept
        ]
        Apiservers.shared.postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let msg = response[ServerKey.message.rawValue] as? String{
                completion(msg)
            }else{
                completion("failed")
                print("the user login failed because of the wrong value!")
            }
        }
    }
}
