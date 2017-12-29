//
//  NotificationList.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//

import Foundation
import Unbox

enum NotificationListServerKey: String {
    case notification = "notification"
}

struct NotificationList {
    var notification: [Notification]
}

extension NotificationList: Unboxable {
    init(unboxer: Unboxer) throws {
        self.notification = try unboxer.unbox(key: NotificationListServerKey.notification.rawValue)
    }
}
