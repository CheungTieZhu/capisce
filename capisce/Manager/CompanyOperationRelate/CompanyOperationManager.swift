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
    
    func getCurrentCompany() -> CompanyDetail? {
        return currentCompanyDetail
    }
    func getCompanyInfo(company: String,completion: @escaping (String?) -> Void){
        let route = "/companyOperation/getInfo"
        let parameters:[String: Any] = [
            CompanyServerKey.company.rawValue: company
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

}
