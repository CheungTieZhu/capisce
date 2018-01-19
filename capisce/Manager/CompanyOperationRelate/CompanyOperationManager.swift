//
//  CompanyOperationManager.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/27.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

class CompanyOperationManager: NSObject{
    static let shared = CompanyOperationManager()
    private var currentCompanyDetail: CompanyDetail?
    private var multipleUser: MultipleUser?
    
    func getMultipleUser() -> MultipleUser? {
        return multipleUser
    }
    
    func getCurrentCompany() -> CompanyDetail? {
        return currentCompanyDetail
    }
    func getCompanyInfo(company: String,completion: @escaping (String?) -> Void){
        let route = "/companyOperation/getInfo"
        let parameters:[String: Any] = [
            CompanyServerKey.company.rawValue: company
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
                            print(data)
                            let companyInfo: CompanyDetail = try unbox(dictionary: data)
                            self.currentCompanyDetail = companyInfo
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
    
    func postRegisterNewMember(company: String,userName: String,realName: String,companyIcon: String,headImageUrl: String,completion: @escaping (String?) -> Void){
        let route = "/companyOperation/agree"
        let parameters:[String: Any] = [
            CompanyOrganizationKey.userName.rawValue: userName,
            CompanyStructKey.company.rawValue: company,
            CompanyOrganizationKey.realName.rawValue: realName,
            CompanyStructKey.companyIcon.rawValue: companyIcon,
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
    
    func postSearchPerson(realName: String,company: String,completion: @escaping (String?) -> Void){
        let route = "/companyOperation/searchPerson"
        let parameters:[String: Any] = [
            CompanyOrganizationKey.realName.rawValue: realName,
            CompanyStructKey.company.rawValue: company
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
    
    func postSetupOrganization(company: String,userName: String,note: String,department: String,organizationName: String,request: Int,completion: @escaping (String?) -> Void){
        let route = "/companyOperation/addOrganization"
        let parameters:[String: Any] = [
            CompanyOrganizationKey.userName.rawValue: userName,
            CompanyStructKey.company.rawValue: company,
            ServerKey.department.rawValue: department,
            ServerKey.request.rawValue: request,
            ServerKey.organizationName.rawValue: organizationName
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
    
    func postGetDepartment(company: String,completion: @escaping (String?,[String]) -> Void){
        let route = "/companyOperation/getDepartment"
        let parameters:[String: Any] = [
            CompanyStructKey.company.rawValue: company
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
                    if let data = response[ServerKey.data.rawValue] as? [String]{
                            completion(msg,data)
                    }else{
                        completion(msg,[])
                    }
                }else{
                    completion(msg,[])
                    print("user Log in fail")
                }
            }else{
                completion("failed",[])
                print("the user login failed because of the wrong value!")
            }
        }
    }
    
}
