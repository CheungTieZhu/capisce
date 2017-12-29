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
            if let headImageUrl = parentVC.userInfoDictionary?.multipleUser[indexPath.row].headImageUrl,let registerStatus = parentVC.userInfoDictionary?.multipleUser[indexPath.row].registerStatus,let imgUrl = URL(string: headImageUrl),let realName = parentVC.realNameDisplay{
                cell.registerStatusLabel.text = registerStatus
                cell.userImage.af_setImage(withURL: imgUrl)
                cell.realNameLabel.text = realName
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
