//
//  CompanyManage.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/23.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

class CompanyManage: NSObject{
    static let shared = CompanyManage()
    private var currentCompany: Company?
    
    func getCurrentCompany() -> Company? {
        return currentCompany
    }
    func getCompanyInfo(userName: String,userToken: String,completion: @escaping (String?) -> Void){
        let route = "/company/getInfo"
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
                            let companyInfo: Company = try unbox(dictionary: data)
                            self.currentCompany = companyInfo
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
    
    func createCompany(userName: String,company: String,business: String,description: String,companyIcon: String,completion: @escaping (String?,String?) -> Void){
        let route = "/company/createCompany"
        let parameters:[String: Any] = [
            ServerKey.userName.rawValue: userName,
            CompanyServerKey.company.rawValue: company,
            CompanyDetailServerKey.business.rawValue: business,
            CompanyDetailServerKey.description.rawValue: description,
            CompanyDetailServerKey.companyIcon.rawValue: companyIcon
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
}
