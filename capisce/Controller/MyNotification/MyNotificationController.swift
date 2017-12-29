//
//  MyNotificationController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import AlamofireImage

class MyNotificationController: UITableViewController{
    
    var notificationDictionary: NotificationList?
    
    @IBOutlet var NotificationTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNotificationInfo()
    }
    
    private func getNotificationInfo(){
        if let currentUser = UserProfileManage.shared.getCurrentUser(),let userName = currentUser.userName{
            NotificationManage.shared.postGetNotification(userName: userName, completion: { (result) in
                if result == "success"{
                    if let notification = NotificationManage.shared.getNotification(){
                        self.notificationDictionary = notification
                        self.NotificationTable.reloadData()
                    }
                }else{
                    self.displayGlobalAlert(title: "错误", message: "获取信息失败", action: "OK", completion: nil)
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let number = notificationDictionary?.notification.count{
            return number
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NotificationTable.dequeueReusableCell(withIdentifier: "notificationCellId", for: indexPath) as! NotificationCell
        if let userName = notificationDictionary?.notification[indexPath.row].userName,let currentUser = UserProfileManage.shared.getCurrentUser(),let currentUserName = currentUser.userName{
            if currentUserName == userName{
                if let company = notificationDictionary?.notification[indexPath.row].company,let companyIcon = notificationDictionary?.notification[indexPath.row].companyIcon,let request = notificationDictionary?.notification[indexPath.row].request,let imgUrl = URL(string: companyIcon),let action = notificationDictionary?.notification[indexPath.row].accept{
                    cell.showRoleLabel.text = "公司:"
                    cell.showLabel.text = company
                    cell.showImage.af_setImage(withURL: imgUrl)
                    switch request{
                    case 0:
                    cell.requestLabel.text = requestStatus.addMember.rawValue
                    case 1:
                    cell.requestLabel.text = requestStatus.kickOut.rawValue
                    default:
                    cell.requestLabel.text = requestStatus.addMember.rawValue
                    }
                    switch action{
                    case 0:
                        cell.notificationImage.isHidden = false
                        cell.actionLable.text = requestAction.unread.rawValue
                    case 1:
                        cell.notificationImage.isHidden = true
                        cell.actionLable.text = requestAction.readed.rawValue
                    case 2:
                        cell.notificationImage.isHidden = true
                        cell.actionLable.text = requestAction.accepted.rawValue
                    case 3:
                        cell.notificationImage.isHidden = true
                        cell.actionLable.text = requestAction.rejected.rawValue
                    default:
                        cell.actionLable.text = requestAction.unread.rawValue
                    }
                }
            }else{
                if let realName = notificationDictionary?.notification[indexPath.row].realName,let userHeadImage = notificationDictionary?.notification[indexPath.row].userHeadImage,let imgUrl = URL(string: userHeadImage),let request = notificationDictionary?.notification[indexPath.row].request,let action = notificationDictionary?.notification[indexPath.row].accept{
                    cell.showRoleLabel.text = "用户:"
                    cell.showLabel.text = realName
                    cell.showImage.af_setImage(withURL: imgUrl)
                    switch request{
                    case 0:
                        cell.requestLabel.text = requestStatus.addMember.rawValue
                    case 1:
                        cell.requestLabel.text = requestStatus.kickOut.rawValue
                    default:
                        cell.requestLabel.text = requestStatus.addMember.rawValue
                    }
                    switch action{
                    case 0:
                        cell.notificationImage.isHidden = false
                        cell.actionLable.text = requestAction.unread.rawValue
                    case 1:
                        cell.notificationImage.isHidden = true
                        cell.actionLable.text = requestAction.readed.rawValue
                    case 2:
                        cell.notificationImage.isHidden = true
                        cell.actionLable.text = requestAction.accepted.rawValue
                    case 3:
                        cell.notificationImage.isHidden = true
                        cell.actionLable.text = requestAction.rejected.rawValue
                    default:
                        cell.actionLable.text = requestAction.unread.rawValue
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
