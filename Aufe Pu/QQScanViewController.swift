//
//  QQScanViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import swiftScan
import RKDropdownAlert
import SwiftyJSON
import Alamofire
import AES256CBC


class QQScanViewController: LBXScanViewController {

    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle:UILabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
// MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //底部显示的功能项
    var bottomItemsView:UIView?
    
    //相册
    var btnPhoto:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    //我的二维码
    var btnMyQR:UIButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawBottomItems()
    }
    
    
  
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        for result:LBXScanResult in arrayResult
        {
            print("%@",result.strScanned)
        }
        
        let result:LBXScanResult = arrayResult[0]
        
        
        self.isOpenedFlash = true
        self.startScan()
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        
        // 派发到刚创建的队列中，GCD 会负责进行线程调度
        concurrentQueue.async {
            
            
            self.getI(userid: result.strScanned!)

        }

//        let vc = ScanResultController()
//        vc.codeResult = result
//        navigationController?.pushViewController(vc, animated: true)
    }
    func getI(userid:String){
        
        
        
        if userid.range(of: "=")?.isEmpty == false {
            
            let aes = AES256CBC.decryptString(userid, password: "R8T2bG4P2qs56btTPDeB29e52I6GMzAB")
            print("解密后的  \(aes)")
            
            
            getactivityID(userid: aes!)
        
        }
        
        
        if userid.range(of: "=")?.isEmpty == nil {
            
            OriginalGet(strScanned: userid)

        }


    
    }
    //原始获取方式  获取activityID 后执行新方式
    func OriginalGet(strScanned:String) {
        let activityID = ActivityManageTableViewController.activityID
        NSLog("activityID      \(activityID)")
        
        Alamofire.request("http://i.ancai.cc/StudentWX/User/GetUserIDByEwm?activityID=\(JSON(activityID).stringValue)&ewm=\(strScanned)")
        .responseString { (DataResponse) in
            switch DataResponse.result{
            case .success(let data):
                
                print("OriginalGet  \(DataResponse.request)")

                let sunstring = JSON(data).rawString() as! NSString
                if sunstring.substring(to: 7) == "success" {
                   let a =  sunstring.components(separatedBy: CharacterSet(charactersIn: ":"))
                    self.getactivityID(userid:a[1])
                }else{
                RKDropdownAlert.title("识别失败", message: "\(data)")
                }
            case .failure(let error):
                NSLog("\(error.localizedDescription)")

            }
        }
    }
    //签到开始
    func getactivityID(userid:String)  {
        let activityID = ActivityManageTableViewController.activityID
        Alamofire.request("http://i.ancai.cc/StudentWX/User/ActivityQd?activityID=\(JSON(activityID).stringValue)&userID=\(userid)")
        .responseString { (DataResponse) in
            switch DataResponse.result{
            case .success(let DataResponseda):
                print("\(DataResponseda)")
                let data = JSON(DataResponseda).stringValue
                
                
                
                switch data {
                case "权限不足":
                    RKDropdownAlert.title("失败", message: "无权限")

                case "该同学没有上传头像，不允许签到":
                    RKDropdownAlert.title("失败", message: "该同学没有上传头像，不允许签到")

                case "该同学已签到":
                    RKDropdownAlert.title("失败", message: "该同学已签到")

                case "success":
                     RKDropdownAlert.title("成功", backgroundColor: UIColor(hue: 89.0/255.0, saturation: 83.0/255.0, brightness: 84.0/255.0, alpha: 1), textColor: UIColor.red)
                default:
                    RKDropdownAlert.title("失败", message: "不明原因 请联系开发者 \(data)")

                
                }
                
    

            case .failure(let error):
                RKDropdownAlert.title("网络连接失败  如微信可访问 请联系开发者 报告错误信息", message: "\(error.localizedDescription)")
            }
        }
    }
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        
        bottomItemsView = UIView(frame:CGRect(x: 0.0, y: yMax-100,width: self.view.frame.size.width, height: 100 ) )
        
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        
        let size = CGSize(width: 65, height: 87);
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        btnFlash.addTarget(self, action: #selector(QQScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        
        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/4, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControlState.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControlState.highlighted)
        btnPhoto.addTarget(self, action: #selector(LBXScanViewController.openPhotoAlbum), for: UIControlEvents.touchUpInside)
        
        
        self.btnMyQR = UIButton()
        btnMyQR.bounds = btnFlash.bounds;
        btnMyQR.center = CGPoint(x: bottomItemsView!.frame.width * 3/4, y: bottomItemsView!.frame.height/2);
        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), for: UIControlState.normal)
        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), for: UIControlState.highlighted)
        btnMyQR.addTarget(self, action: #selector(QQScanViewController.myCode), for: UIControlEvents.touchUpInside)
        
        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
        bottomItemsView?.addSubview(btnMyQR)
        
        self.view .addSubview(bottomItemsView!)
        
    }
    
    //开关闪光灯
    func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControlState.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        }
    }
    
    func myCode()
    {
        let vc = MyCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
