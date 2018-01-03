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
    case userToken = "userToken"
    case userName  = "userName"
    case password  = "password"
    case phone     = "phone"
    case email     = "email"
    case timestamp = "timestamp"
    case pageCount = "page_count"
    case offset = "offset"
    case userType = "user_type"
    case deviceToken = "deviceToken"
    case realName = "realName"
    case tripId = "trip_id"
    case userId = "user_id"
    case sinceTime = "since_time"
    case registerStatus = "registerStatus"
}

// if changes the key in this map, MUST change also in the flagsTitle array
// *** the order of flags in flagsTitle should NOT be change!!!
let codeOfFlag : [String:String] = ["🇨🇳 +86":"86","🇺🇸  +1":"1", "🇭🇰 852":"852", "🇦🇺 +61":"61", "🇬🇧 +44":"44", "🇩🇪 +49":"49"]
let Flag : [String:String] = ["🇨🇳 +86":"🇨🇳","🇺🇸  +1":"🇺🇸","🇭🇰 852":"🇭🇰", "🇦🇺 +61":"🇦🇺", "🇬🇧 +44":"🇬🇧", "🇩🇪 +49":"🇩🇪"]
var flagsTitle : [String] = ["🇨🇳 +86","🇺🇸  +1","🇭🇰 852", "🇦🇺 +61", "🇬🇧 +44", "🇩🇪 +49"]
/// AWS server keys
let awsIdentityPoolId = "ap-northeast-2:a5682401-65bf-4fe4-b45c-01e4ab198789"
let awsBucketName = "capiscepicture"
let awsPublicBucketName = "capiscepublic"
//get user Info
var justLogIn: Bool = false
let imageCompress: CGFloat = 0.1

enum requestStatus: String{
    case addMember = "请求添加"
    case kickOut = "移出组织"
}

enum requestAction: String{
    case unread = "未读"
    case readed = "已读"
    case accepted = "已同意"
    case rejected = "已拒绝"
}

enum ImageTypeOfID : String {
    case userHeadImage = "userHeadImage"
    case companyIcon = "companyIcon"
}
