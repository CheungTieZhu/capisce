//
//  Apiservers.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/14.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

class Apiservers: NSObject{
    static let shared = Apiservers()
    private let appToken: String = "0123456789012345678901234567890123456789012345678901234567890123"
    private let host = "http://192.168.1.172:8080"
    
    private let hostVersion = ""
    
    enum ServerKey: String {
        case data = "data"
        case statusCode = "status_code"
        case message = "message"
        case appToken = "app_token"
        case userToken = "user_token"
        case userName  = "userName"
        case password  = "password"
        case countryCode = "country_code"
        case phone     = "phone"
        case email     = "email"
        case timestamp = "timestamp"
        case pageCount = "page_count"
        case offset = "offset"
        case userType = "user_type"
        case deviceToken = "device_token"
        case realName = "real_name"
        case tripId = "trip_id"
        case userId = "user_id"
        case sinceTime = "since_time"
    }
    
    func postLoginUser(userName: String? = nil,
                       password: String,
                       completion: @escaping (String?, Error?) -> Void) { //(token, username), error
        
//        let deviceToken = UserDefaults.getDeviceToken() ?? ""
        
        let route = hostVersion + "/user/login"
        
        var parameter:[String: Any] = [
            ServerKey.password.rawValue: password
        ]
        if let userName = userName {
            parameter [ServerKey.userName.rawValue] = userName
        }
        
        getDataWithUrlRoute(route,parameters: parameter){ (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                return
            }
            if let msg = response[ServerKey.message.rawValue] as? String{
                if msg == "success"{
                    if let data = response[ServerKey.data.rawValue] as? [String: Any]{
                        completion(msg,nil)
                    }else{
                        completion(msg,error)
                    }
                }else{
                    completion(msg,error)
                    print("user Log in fail")
                }
            }else{
                completion("fail",error)
                print("the user login failed because of the wrong value!")
            }
        }
    }
    
    // MARK: - basic GET and POST by url
    /**
     * ✅ get data with url string, return NULL, try with Alamofire and callback
     */
    private func getDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
        let requestUrlStr = host + route
        
        Alamofire.request(requestUrlStr, parameters: parameters).responseJSON { response in
            
            if let urlRequest = response.request?.url {
                let printText: String = """
                =========================
                [GET ROUTE] \(route)
                [REQUEST] \(urlRequest)
                """
                print(printText)
            }
            
            if let responseValue = response.value as? [String: Any] {
                if let statusCode = responseValue[ServerKey.statusCode.rawValue] as? Int, statusCode != 200 {
                    let message = responseValue[ServerKey.message.rawValue] ?? ""
                    let printText: String = """
                    =========================
                    [STATUS_CODE] \(statusCode)
                    [MESSAGE]: \(message)
                    """
                    print(printText)
                    
                    self.handleAbnormalStatusCode(statusCode)
                }
                
                completion(responseValue, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    /**
     * ✅ POST data with url string, using Alamofire
     */
    private func postDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
        let requestUrlStr = host + route
        Alamofire.request(requestUrlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let requestBody = response.request?.httpBody, let body = NSString(data: requestBody, encoding: String.Encoding.utf8.rawValue) {
                let printText: String = """
                =========================
                [POST ROUTE] \(route)
                [PARAMETERS] \(parameters)
                [BODY] \(body)
                """
                print(printText)
            }
            
            if let responseValue = response.value as? [String: Any] {
                
                if let statusCode = responseValue[ServerKey.statusCode.rawValue] as? Int, statusCode != 200 {
                    let message = responseValue[ServerKey.message.rawValue] ?? ""
                    let printText: String = """
                    =========================
                    [STATUS_CODE] \(statusCode)
                    [MESSAGE]: \(message)
                    """
                    print(printText)
                    
                    self.handleAbnormalStatusCode(statusCode)
                }
                completion(responseValue, nil)
                
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}
extension Apiservers {
    func handleAbnormalStatusCode(_ statusCode: Int) {
        switch statusCode {
        case 401:
            print("wrong")
        default:
            print("[Status Code] Not handled: \(statusCode)")
        }
    }
}

