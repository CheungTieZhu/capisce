//
//  CompanyOrganization.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/29.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Unbox

enum CompanyOrganizationKey: String {
    case userName    = "userName"
    case apartment   = "apartment"
    case team        = "team"
    case level       = "level"
    case realName    = "realName"
}

struct CompanyOrganization {
    let userName: String?
    let apartment: String?
    let team: String?
    let level: Int?
    let realName: String?
}

extension CompanyOrganization: Unboxable {
    init(unboxer: Unboxer) throws {
        self.userName = try? unboxer.unbox(key: CompanyOrganizationKey.userName.rawValue)
        self.apartment = try? unboxer.unbox(key: CompanyOrganizationKey.apartment.rawValue)
        self.team = try? unboxer.unbox(key: CompanyOrganizationKey.team.rawValue)
        self.level = try? unboxer.unbox(key: CompanyOrganizationKey.level.rawValue)
        self.realName = try? unboxer.unbox(key: CompanyOrganizationKey.realName.rawValue)
    }
}
