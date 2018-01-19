//
//  SearchPersonTable.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/30.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit

class SearchPersonTable: UITableViewController{
    @IBOutlet var searchPersonTable: UITableView!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPersonTable.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let parentVC = self.parent as? AddOrganizationController{
            if let number = parentVC.userDictionary?.multipleUser.count{
                return number
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchPersonTable.dequeueReusableCell(withIdentifier: "searchPersonCellId", for: indexPath) as! SearchPersonCell
        if let parentVC = self.parent as? AddOrganizationController{
            if let realName = parentVC.userDictionary?.multipleUser[indexPath.row].realName{
                cell.userRealName.text = realName
                cell.userHeadImg.layer.masksToBounds = true
                cell.userHeadImg.layer.cornerRadius = CGFloat(Int(cell.userHeadImg.frame.width)/2)
                if let headImageUrl = parentVC.userDictionary?.multipleUser[indexPath.row].headImageUrl,let imgUrl = URL(string: headImageUrl){
                    cell.userHeadImg.af_setImage(withURL: imgUrl)
                }else{
                    cell.userHeadImg.image = #imageLiteral(resourceName: "userDefault")
                }
                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parentVC = self.parent as? AddOrganizationController{
            index = indexPath.row
            parentVC.saveButton.isEnabled = true
        }
    }
}
