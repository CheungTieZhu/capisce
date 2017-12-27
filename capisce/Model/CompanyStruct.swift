//
//  CompanyStruct.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/25.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Unbox

enum CompanyStructKey: String {
    case company     = "company"
    case apartment   = "apartment"
    case team        = "team"
    case level       = "level"
}

struct CompanyStruct {
    let company: String?
    let apartment: String?
    let team: String?
    let level: Int?
}

extension CompanyStruct: Unboxable {
    init(unboxer: Unboxer) throws {
        self.company = try? unboxer.unbox(key: CompanyStructKey.company.rawValue)
        self.apartment = try? unboxer.unbox(key: CompanyStructKey.apartment.rawValue)
        self.team = try? unboxer.unbox(key: CompanyStructKey.team.rawValue)
        self.level = try? unboxer.unbox(key: CompanyStructKey.level.rawValue)
    }
}

