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
                            self.currentCompany?.printAllData()
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
