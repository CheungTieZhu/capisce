//
//  UserOperationController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/23.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit

enum userPosition: String {
    case administator     = "Administator"
    case manager          = "Manager"
    case apartmentLeadr   = "Apartment Leader"
    case teamLeader       = "Team Leader"
    case teamMember       = "Team Member"
}

class UserOperationController: UITableViewController{
    
    @IBOutlet var userOperationTable: UITableView!
    var level: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLevel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userOperationTable.reloadData()
    }
    
    private func getUserLevel(){
        if let parentVC = self.parent as? UserInfoController{
            let companyIndex = parentVC.companyIndex
            level = parentVC.companyDict?.company[companyIndex].level
        }
    }
}
extension UserOperationController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getUserLevel()
        switch level {
        case 4?:
            return 8
        case 3?:
            return 7
        case 2?:
            return 7
        case 1?:
            return 7
        case 0?:
            return 5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userOperationTable.dequeueReusableCell(withIdentifier: "userOperationCellId", for: indexPath) as! UserOperationCell
        if let parentVC = self.parent as? UserInfoController{
            let companyIndex = parentVC.companyIndex
            if let company = parentVC.companyDict?.company[companyIndex].company,let apartment = parentVC.companyDict?.company[companyIndex].apartment,let team = parentVC.companyDict?.company[companyIndex].team,let position = level{
                switch indexPath.row{
                case 0:
                    cell.itemNameLabel.text = "company"
                    cell.itemExpressionLabel.text = company
                case 1:
                    cell.itemNameLabel.text = "apartment"
                    cell.itemExpressionLabel.text = apartment
                case 2:
                    cell.itemNameLabel.text = "team"
                    cell.itemExpressionLabel.text = team
                case 3:
                    cell.itemNameLabel.text = "position"
                    switch position{
                    case 4:
                        cell.itemExpressionLabel.text = userPosition.administator.rawValue
                    case 3:
                        cell.itemExpressionLabel.text = userPosition.manager.rawValue
                    case 2:
                        cell.itemExpressionLabel.text = userPosition.apartmentLeadr.rawValue
                    case 1:
                        cell.itemExpressionLabel.text = userPosition.teamLeader.rawValue
                    default:
                        cell.itemExpressionLabel.text = userPosition.teamMember.rawValue
                    }
                case 4:
                    cell.itemNameLabel.text = "View Member"
                    cell.itemExpressionLabel.text = "Member"
                case 5:
                    cell.itemNameLabel.text = "Manage Task"
                    cell.itemExpressionLabel.text = "Task"
                case 6:
                    cell.itemNameLabel.text = "View Member"
                    cell.itemExpressionLabel.text = "Position"
                case 7:
                    cell.itemNameLabel.text = "Manage Member"
                    cell.itemExpressionLabel.text = "Member"
                default:
                    cell.itemNameLabel.text = "company"
                    cell.itemExpressionLabel.text = company
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

