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
    case company     = "company"
    case apartment   = "apartment"
    case team        = "team"
    case level       = "level"
}

class Company: Unboxable  {
    
    var company: String?
    var apartment: String?
    var team: String?
    var level: Int?
    init() {
        //Initialization
    }
    
    func printAllData(){
        let allData = """
        company = \(company ?? "")
        apartment = \(apartment ?? "")
        team = \(team ?? "")
        level = \(level ?? 0),
        """
        print(allData)
    }
    
    required init(unboxer: Unboxer) throws {
        self.company = try? unboxer.unbox(key: CompanyServerKey.company.rawValue)
        self.apartment = try? unboxer.unbox(key: CompanyServerKey.apartment.rawValue)
        self.team = try? unboxer.unbox(key: CompanyServerKey.team.rawValue)
        self.level = try? unboxer.unbox(key: CompanyServerKey.level.rawValue)
    }
}
