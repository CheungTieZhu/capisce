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
    
    var index :Int = 0
    
    var notificationDictionary: NotificationList?
    
    @IBOutlet var NotificationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationTable.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNotificationInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotificationDetail"{
            if let showInfoVC = segue.destination as? NotificationDetailController{
                    showInfoVC.notificationDictionary = notificationDictionary
                    showInfoVC.index = index
            }
        }
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
        cell.showImage.layer.masksToBounds = true
        cell.showImage.layer.cornerRadius = CGFloat(Float(cell.showImage.frame.width)/2)
        cell.notificationImage.layer.masksToBounds = true
        cell.notificationImage.layer.cornerRadius = CGFloat(Float(cell.notificationImage.frame.width)/2)
        if let userName = notificationDictionary?.notification[indexPath.row].userName,let currentUser = UserProfileManage.shared.getCurrentUser(),let currentUserName = currentUser.userName,let action = notificationDictionary?.notification[indexPath.row].accept,let senderAction = notificationDictionary?.notification[indexPath.row].senderAccept{
            if currentUserName == userName{
                if let company = notificationDictionary?.notification[indexPath.row].company,let request = notificationDictionary?.notification[indexPath.row].request{
                    if let companyIcon = notificationDictionary?.notification[indexPath.row].companyIcon,let imgUrl = URL(string: companyIcon){
                        cell.showImage.af_setImage(withURL: imgUrl)
                    }else{
                        cell.showImage.image = #imageLiteral(resourceName: "capisce_company")
                    }
                    cell.showRoleLabel.text = "公司:"
                    cell.showLabel.text = company
                    
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
                if let realName = notificationDictionary?.notification[indexPath.row].realName,let request = notificationDictionary?.notification[indexPath.row].request{
                    cell.showRoleLabel.text = "用户:"
                    cell.showLabel.text = realName
                    if let userHeadImage = notificationDictionary?.notification[indexPath.row].userHeadImage,let imgUrl = URL(string: userHeadImage){
                        cell.showImage.af_setImage(withURL: imgUrl)
                    }else{
                        cell.showImage.image = #imageLiteral(resourceName: "userDefault")
                    }
                    switch request{
                    case 0:
                        cell.requestLabel.text = requestStatus.addMember.rawValue
                    case 1:
                        cell.requestLabel.text = requestStatus.kickOut.rawValue
                    default:
                        cell.requestLabel.text = requestStatus.addMember.rawValue
                    }
                    switch senderAction{
                    case 0:
                        cell.notificationImage.isHidden = true
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
        return 120
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        if let action = notificationDictionary?.notification[indexPath.row].accept,let id = notificationDictionary?.notification[indexPath.row].id{
            if action == 0{
                NotificationManage.shared.postUserLocalAction(id: id, accept: 1, completion: { (result) in
                    if result == "success"{
                        self.performSegue(withIdentifier: "showNotificationDetail", sender: nil)
                    }else{
                        self.displayGlobalAlert(title: "错误", message: "获取错误", action: "ok", completion: nil)
                    }
                })
            }else{
                self.performSegue(withIdentifier: "showNotificationDetail", sender: nil)
            }
        }
    }
}
