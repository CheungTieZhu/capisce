//
//  SearchUserTable.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/28.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchUserTable: UITableViewController{
    
    @IBOutlet var userDisplayTable: UITableView!
    var index: Int?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let parentVC = self.parent as? AddMemberController{
            if let number = parentVC.userInfoDictionary?.multipleUser.count{
                return number
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userDisplayTable.dequeueReusableCell(withIdentifier: "SearchTableCellId", for: indexPath) as! SearchUserCell
        if let parentVC = self.parent as? AddMemberController{
            if let registerStatus = parentVC.userInfoDictionary?.multipleUser[indexPath.row].registerStatus,let realName = parentVC.realNameDisplay{
                cell.registerStatusLabel.text = registerStatus
                cell.realNameLabel.text = realName
                cell.userImage.layer.masksToBounds = true
                cell.userImage.layer.cornerRadius = CGFloat(Int(cell.userImage.frame.width)/2)
                if let headImageUrl = parentVC.userInfoDictionary?.multipleUser[indexPath.row].headImageUrl,let imgUrl = URL(string: headImageUrl){
                    cell.userImage.af_setImage(withURL: imgUrl)
                }else{
                    cell.userImage.image = #imageLiteral(resourceName: "userDefault")
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parentVC = self.parent as? AddMemberController{
            index = indexPath.row
            parentVC.sendButton.isEnabled = true
        }
    }
}
