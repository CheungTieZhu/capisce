//
//  Notification.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Unbox

enum NotificationInfoKey: String {
    case userName        = "userName"
    case senderUserName  = "senderUserName"
    case request         = "request"
    case requestDate     = "requestDate"
    case accept          = "accept"
    case company         = "company"
    case userHeadImage   = "userHeadImage"
    case companyIcon     = "companyIcon"
    case note            = "note"
    case realName        = "realName"
}

struct Notification {
    let userName: String?
    let senderUserName: String?
    let request: Int?
    let requestDate: String?
    let accept: Int?
    let company: String?
    let userHeadImage: String?
    let companyIcon: String?
    let note: String?
    let realName: String?
}

extension Notification: Unboxable {
    init(unboxer: Unboxer) throws {
        self.userName = try? unboxer.unbox(key: NotificationInfoKey.userName.rawValue)
        self.senderUserName = try? unboxer.unbox(key: NotificationInfoKey.senderUserName.rawValue)
        self.request = try? unboxer.unbox(key: NotificationInfoKey.request.rawValue)
        self.requestDate = try? unboxer.unbox(key: NotificationInfoKey.requestDate.rawValue)
        self.accept = try? unboxer.unbox(key: NotificationInfoKey.accept.rawValue)
        self.company = try? unboxer.unbox(key: NotificationInfoKey.company.rawValue)
        self.userHeadImage = try? unboxer.unbox(key: NotificationInfoKey.userHeadImage.rawValue)
        self.companyIcon = try? unboxer.unbox(key: NotificationInfoKey.companyIcon.rawValue)
        self.note  = try? unboxer.unbox(key: NotificationInfoKey.note.rawValue)
        self.realName  = try? unboxer.unbox(key: NotificationInfoKey.realName.rawValue)
    }
}
