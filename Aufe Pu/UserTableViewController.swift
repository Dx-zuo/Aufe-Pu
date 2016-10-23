//
//  UserTableViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/19.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import AVFoundation
class UserTableViewController: UITableViewController {
    let UserCell = "UserCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserCell)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 1
        }
        return 8
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell, for: indexPath) as! UserTableViewCell

        switch indexPath.section{
        case 0:
            if indexPath.row == 0 {
                cell.Title.text = "我参加的活动"
                cell.CellImage.image = UIImage(named: "个性化")
            }else{
                cell.Title.text = "我参加的学生组织"
                cell.CellImage.image = UIImage(named: "特色")
            }
        case 1 :
            if indexPath.row == 0{
                cell.Title.text = "我的实践学分"
                cell.CellImage.image = UIImage(named: "积分")
            }
                if indexPath.row == 1 {
  
                    cell.Title.text = "我的二维码"
                    cell.CellImage.image = UIImage(named: "图片")
                }
            if indexPath.row == 2 {
                cell.Title.text = "修改密码"
                cell.CellImage.image = UIImage(named: "鲜花")
            }

        case 2 :
            cell.Title.text = "设置"
            cell.CellImage.image = UIImage(named: "设置")
        case 3 :
            cell.Title.text = "bug 反馈&& 你的建议"
            cell.CellImage.image = UIImage(named: "人数")
        default:
            print("123")

        }

        cell.CellImage.frame.size.height = 29
        cell.CellImage.frame.size.width = 29
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        var ID : String = ""
        var Titlee :String = ""
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                ID = "/StudentWX/User/MyActivity"
                Titlee = "我参加的活动"
            }
            if indexPath.row == 1 {
                ID = "/StudentWX/User/MyOrganize"
                Titlee = "我参加的学生组织"
            
            }
        case 1:
            if indexPath.row == 0 {
                ID = "/StudentWX/User/MyCredit"
                Titlee = "我的实践学分"
                
            }
            if indexPath.row == 1 {
                ID = "/StudentWX/User/MyEwm"
                Titlee = "我的二维码"
                
            }
            if indexPath.row == 2 {
                ID = "/StudentWX/User/ChangePassword"
                Titlee = "修改密码"
            }
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Settings") as! SettingsTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 3:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Help")
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
        
        let arr = ["ID":ID,"Title":Titlee] as [String : Any]
        self.performSegue(withIdentifier: "UserWebId", sender: arr)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserWebId"{
            let vc = segue.destination as! WebViewController
            vc.hidesBottomBarWhenPushed = true
            let data = sender as! [String : Any]
            vc.webID = data["ID"] as! String
            vc.Webtitle = data["Title"] as! String
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
