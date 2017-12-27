//
//  Company.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/23.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

enum CompanyServerKey: String {
    case company = "company"
}

struct Company {
    var company: [CompanyStruct]
}

extension Company: Unboxable {
    init(unboxer: Unboxer) throws {
        self.company = try unboxer.unbox(key: CompanyServerKey.company.rawValue)
    }
}
