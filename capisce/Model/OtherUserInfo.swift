//
//  OtherUserInfo.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//
import UIKit
import Unbox

enum OtherUserInfoKey: String {
    case userName              = "userName"
    case headImageUrl          = "headImageUrl"
    case registerStatus        = "registerStatus"
}

struct OtherUserInfo {
    let userName: String?
    let headImageUrl: String?
    let registerStatus: String?
}

extension OtherUserInfo: Unboxable {
    init(unboxer: Unboxer) throws {
        self.userName = try? unboxer.unbox(key: OtherUserInfoKey.userName.rawValue)
        self.headImageUrl = try? unboxer.unbox(key: OtherUserInfoKey.headImageUrl.rawValue)
        self.registerStatus = try? unboxer.unbox(key: OtherUserInfoKey.registerStatus.rawValue)
    }
}
