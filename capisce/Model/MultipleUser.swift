//
//  MultipleUser.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

enum MultipleUserServerKey: String {
    case multipleUser = "multipleUser"
}

struct MultipleUser {
    var multipleUser: [OtherUserInfo]
}

extension MultipleUser: Unboxable {
    init(unboxer: Unboxer) throws {
        self.multipleUser = try unboxer.unbox(key: MultipleUserServerKey.multipleUser.rawValue)
    }
}
