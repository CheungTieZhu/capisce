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
    
    // MARK: - basic GET and POST by url
    /**
     * ✅ get data with url string, return NULL, try with Alamofire and callback
     */
    func getDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
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
    func postDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
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

