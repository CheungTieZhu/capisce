//
//  GlobalVariable.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/21.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation

enum ServerKey: String {
    case result = "result"
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
    case deviceToken = "deviceToken"
    case realName = "real_name"
    case tripId = "trip_id"
    case userId = "user_id"
    case sinceTime = "since_time"
}

// if changes the key in this map, MUST change also in the flagsTitle array
// *** the order of flags in flagsTitle should NOT be change!!!
let codeOfFlag : [String:String] = ["🇨🇳 +86":"86","🇺🇸  +1":"1", "🇭🇰 852":"852", "🇦🇺 +61":"61", "🇬🇧 +44":"44", "🇩🇪 +49":"49"]
let Flag : [String:String] = ["🇨🇳 +86":"🇨🇳","🇺🇸  +1":"🇺🇸","🇭🇰 852":"🇭🇰", "🇦🇺 +61":"🇦🇺", "🇬🇧 +44":"🇬🇧", "🇩🇪 +49":"🇩🇪"]
var flagsTitle : [String] = ["🇨🇳 +86","🇺🇸  +1","🇭🇰 852", "🇦🇺 +61", "🇬🇧 +44", "🇩🇪 +49"]
