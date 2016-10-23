//
//  SettingsTableViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/22.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import YYWebImage
import SwiftyJSON
import RKDropdownAlert
class SettingsTableViewController: UITableViewController {
    var cache :YYImageCache!
    @IBOutlet weak var cacheLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        cache = YYWebImageManager.shared().cache
        let diskCache = cache?.diskCache
        let memoryCache = cache?.memoryCache
        var num = (JSON(diskCache?.totalCost()).floatValue + JSON(memoryCache?.totalCost).floatValue + JSON(diskCache?.totalCount()).floatValue + JSON(memoryCache?.totalCount).floatValue)
        guard  num != 0 else {
            cacheLabel.text = "00.0 M"
            return
        }
        cacheLabel.text = "\(NSString(string: JSON(num/1024/1024).stringValue).substring(to: 3)) M"
        print("\(cache?.diskCache.totalCost())  \(cache?.diskCache.totalCount())  \(cache?.memoryCache.totalCost)  \(cache?.memoryCache.totalCount) ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        }else{
        return 1
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cache.diskCache.removeAllObjects({
                    let alertController = UIAlertController(title: "清理完成", message: "已经成功清理", preferredStyle: .alert)
                    var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                    var okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                    self.cacheLabel.text = "00.0 M"
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil);

                })
            }
        case 1:
            let alertController = UIAlertController(title: "0.0", message: "真的需要注销并清理你的用户数据嘛?", preferredStyle: .alert)
            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            var okAction = UIAlertAction(title: "是的", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.Quitview()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil);

        default:
            NSLog("")
        }


    }
    func Quitview()  {
        UserDefaults.standard.removeObject(forKey: "Username")
        UserDefaults.standard.removeObject(forKey: "Password")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.present(vc, animated: true, completion: {
            print("转场")
        })
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
