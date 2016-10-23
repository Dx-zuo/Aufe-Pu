//
//  ActivityManageTableViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/22.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import Alamofire
import Ji
class ActivityManageTableViewController: UITableViewController{
    struct Activity {
        var title : String = ""
        var date:String = ""
        var register :String = ""
        var petitioner : String = ""
        var member :String = ""
        var state : String = ""
    }
    var Activitynum : Int = 0
    var ActivityModel = [Activity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        parse()
        tableView.rowHeight = 125
        tableView.register(UINib(nibName: "ActivityListTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityList")
    }
    func parse()  {
        Alamofire.request("http://i.ancai.cc/StudentWX/User/ActivityManage").responseString { (DataResponse) in
            switch DataResponse.result {
            case .success(let data):
                let jidoc = Ji(htmlString: data)
                let model = jidoc?.rootNode?.xPath("//li[@class='mui-table-view-cell mui-media']")
                self.Activitynum = (jidoc?.rootNode?.xPath("//button[@class='mui-btn btncolor']").count)!/3

                for (index,i) in (model?.enumerated())!{
                self.ActivityModel.append(self.modelparse(html: i,id: index))
                }
                self.tableView.reloadData()
            case .failure(let error):
                NSLog("\(error.localizedDescription)")
            }
        }
    }
    func modelparse(html:JiNode,id:Int) -> Activity {
        let title = html.xPath("//div[@style='white-space: initial']")[id].content
        let date = html.xPath("//p[@class='mui-ellipsis']")[id].content
        
        if  Activitynum-1 >= id{
            let register = char(style: 1, text: html.descendantsWithName("button")[0]["onclick"]!)
            let petitioner : String = char(style: 2, text: html.descendantsWithName("button")[1]["onclick"]!)
            let member :String = char(style: 2, text: html.descendantsWithName("button")[2]["onclick"]!)
            let state : String = html.descendantsWithName("button")[0]["onclick"]!
            return Activity(title: title!, date: date!, register: register, petitioner: petitioner, member: member, state: state)

        }
        return Activity(title: title!, date: date!, register: "", petitioner: "", member: "", state: "")


    }
    func char(style:Int,text:String) -> String {
        switch style {
        case 1:
            let bb = text.components(separatedBy: CharacterSet(charactersIn: "("))
            bb[1].components(separatedBy: CharacterSet(charactersIn: ","))
            return bb[0]
        case 2:
            let textt = text.components(separatedBy: CharacterSet(charactersIn: "'"))
            return textt[1]
        default:
            print("解析文本  ")
        }
        return text
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ActivityModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityList", for: indexPath) as! ActivityListTableViewCell

        let arrdata = ActivityModel[indexPath.row]
        cell.titleLabel.text = arrdata.title
        cell.dateLabel.text = arrdata.date
        cell.registerBoutton.tag = indexPath.row
        cell.ListButton.tag = indexPath.row
        cell.applicantListButton.tag = indexPath.row
        guard indexPath.row+1 <=  Activitynum else {
            cell.registerBoutton.isHidden = true
            cell.applicantListButton.isHidden = true
            cell.ListButton.isHidden = true
            cell.frame.size.height = 70
            return cell
        }
        cell.registerBoutton.addTarget(self, action: #selector(click(btn:)), for: UIControlEvents.touchDown)
        cell.applicantListButton.addTarget(self, action: #selector(webtouch(btn:)), for: UIControlEvents.touchDown)
        cell.ListButton.addTarget(self, action: #selector(webtouch1(btn:)), for: UIControlEvents.touchDown)

        return cell
    }
    func click(btn:UIButton){
        print("二维码 点击")
        qqStyle()
    }
    func webtouch(btn:UIButton)  {
        let strye = [1,btn.tag]
        self.performSegue(withIdentifier: "ListId", sender: strye)
    }
    func webtouch1(btn:UIButton)  {
        let strye = [2,btn.tag]
        self.performSegue(withIdentifier: "ListId", sender: strye)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListId" {
            let id = sender as! [Int]
            let vc = segue.destination as! WebViewController
            if id[0] == 1 {
                vc.webID = ActivityModel[id[1]].petitioner
                
                vc.Webtitle = "申请列表"
            }else{
                if id[0] == 2 {
                    vc.webID = ActivityModel[id[1]].member
                    vc.Webtitle = "成员管理"
                
                }
            
            }

        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func didTap(_ sender: UIButton) {
        let buttonRect = sender.frame
        for cell in tableView.visibleCells {
            if buttonRect.intersects(cell.frame) {
                //cell就是所要获得的
            }
        }
    }
    func qqStyle()
    {
        
        let vc = QQScanViewController()
        vc.scanStyle.isNeedShowRetangle = true
        vc.scanStyle.whRatio = 1.0
        vc.scanStyle.centerUpOffset = 44
        vc.scanStyle.xScanRetangleOffset = 60
        vc.scanStyle.colorRetangleLine = UIColor.white
        vc.scanStyle.photoframeAngleStyle = .Outer
        vc.scanStyle.colorAngle = UIColor(red: 0.0, green: 167.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        vc.scanStyle.photoframeAngleW = 24.0
        vc.scanStyle.photoframeAngleH = 24
        vc.scanStyle.photoframeLineW = 6
        vc.scanStyle.anmiationStyle  = .LineMove
        vc.scanStyle.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_light_green")
        vc.scanStyle.red_notRecoginitonArea    = 0.0
        vc.scanStyle.green_notRecoginitonArea  = 0.0
        vc.scanStyle.blue_notRecoginitonArea   = 0.0
        vc.scanStyle.alpa_notRecoginitonArea   = 0.5
        self.navigationController?.pushViewController(vc, animated: true)
        
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
