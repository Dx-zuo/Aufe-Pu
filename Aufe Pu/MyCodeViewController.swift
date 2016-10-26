//
//  MyCodeViewController.swift
//  swiftScan
//
//  Created by xialibing on 15/12/10.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import swiftScan
import Alamofire
import SwiftyJSON
import MBProgressHUD
import RKDropdownAlert
import AES256CBC

class MyCodeViewController: UIViewController {

    //二维码
    var qrView = UIView()
    var qrImgView = UIImageView()
    
    //条形码
    var tView = UIView()
    var tImgView = UIImageView()
    
    var textlabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        let right = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(alert))
         self.navigationItem.rightBarButtonItem = right
        drawCodeShowView()
        if UserDefaults.standard.bool(forKey: "QR1") {
            getuserid()
            
        }else{
            createQR1(codeString: JSON(UserDefaults.standard.object(forKey: "QR1")).stringValue)
            
        }
    }
    func alert()  {
            RKDropdownAlert.title("", message: "这个二维码无时间限制  但只能使用小助手扫码使用")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        


    }
    
    //MARK: ------二维码、条形码显示位置
    func drawCodeShowView()
    {
        //二维码
        
        let rect = CGRect(x: (self.view.frame.width-self.view.frame.width*5/6)/2, y: 100, width: self.view.frame.width*5/6, height: self.view.frame.width*5/6)
        qrView.frame = rect
        self.view.addSubview(qrView)
        
        qrView.backgroundColor = UIColor.white
        qrView.layer.shadowOffset = CGSize(width: 0, height: 2);
        qrView.layer.shadowRadius = 2;
        qrView.layer.shadowColor = UIColor.black.cgColor
        qrView.layer.shadowOpacity = 0.5;
        
        qrImgView.bounds = CGRect(x: 0, y: 0, width: qrView.frame.width-12, height: qrView.frame.width-12)
        qrImgView.center = CGPoint(x: qrView.frame.width/2, y: qrView.frame.height/2);
        qrView .addSubview(qrImgView)
        
        
        
        //条形码
        tView.frame = CGRect(x: (self.view.frame.width-self.view.frame.width*5/6)/2,
                             y: rect.maxY+20,
                             width: self.view.frame.width*5/6,
                             height: self.view.frame.width*5/6*0.5)
        self.view .addSubview(tView)
        tView.layer.shadowOffset = CGSize(width: 0, height: 2);
        tView.layer.shadowRadius = 2;
        tView.layer.shadowColor = UIColor.black.cgColor
        tView.layer.shadowOpacity = 0.5;
        
        
        tImgView.bounds = CGRect(x: 0, y: 0, width: tView.frame.width-12, height: tView.frame.height-12);
        tImgView.center = CGPoint(x: tView.frame.width/2, y: tView.frame.height/2);
        tView .addSubview(tImgView)



    }
    func getuserid() {
        var hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "正在生成"
        //背景渐变效果
        hud.dimBackground = true
        let appid = "40w1HFYrwbDPbGjv8RWyvNcP-gzGzoHsz"
        let appkey = "bk661hr3xuTuoufHGpGy72eq"
        //时间戳
        let now = NSDate()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let Sign = String(timeStamp) + appkey
        let headers = [
        "X-LC-Id" : appid,
        "X-LC-Sign": Sign.md5() + "," + String(timeStamp),
        "Content-Type":"application/json"
        ]
        Alamofire.request("https://leancloud.cn:443/1.1/classes/aa?where=%7B%22username%22:%2220140156%22%7D&limit=1&order=-updatedAt", method: .get, headers: headers)
        .responseJSON { (DataResponse) in
            switch DataResponse.result{
            case .success(let data):
                let doc = JSON(data)["results"].first?.1.dictionaryObject?["userid"]
                let codeString = JSON(doc).stringValue

                let aes = AES256CBC.encryptString(codeString, password: "R8T2bG4P2qs56btTPDeB29e52I6GMzAB")

                print("\(codeString)     \(aes)    "  )
                self.createQR1(codeString: aes!)
                UserDefaults.standard.set(aes, forKey: "QR1")
            case .failure(let error):
                NSLog("\(error)")
            }
        }
            hud.hide(true, afterDelay: 0.8)
    }
    
    func createQR1(codeString:String)
    {
       // qrView.hidden = false
       // tView.hidden = true
        
        let qrImg = LBXScanWrapper.createCode(codeType: "CIQRCodeGenerator",codeString:codeString, size: qrImgView.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
        
        let logoImg =  UIImage(named: "")
        qrImgView.image = LBXScanWrapper.addImageLogo(srcImg: qrImg!, logoImg: nil, logoSize: CGSize(width: 30, height: 30))
    }
    
    func createCode128()
    {
        
        let qrImg = LBXScanWrapper.createCode128(codeString: "005103906002", size: qrImgView.bounds.size, qrColor: UIColor.black, bkColor: UIColor.white)
        
       
        tImgView.image = qrImg

    }

    deinit
    {
        print("MyCodeViewController deinit")
    }
   

}
