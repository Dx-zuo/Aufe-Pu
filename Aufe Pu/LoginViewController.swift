//
//  LoginViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/16.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import Alamofire
import Ji
import RKDropdownAlert

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userpass: UITextField!
    @IBOutlet weak var Codetext: UITextField!
    @IBOutlet weak var CodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        CodeImage.isUserInteractionEnabled = true
        CodeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Reimage)))
        username.text = "20140156"
        userpass.text = "960312"
        //
        Alamofire.request("http://i.ancai.cc/StudentPC/Index/CheckCodeImg", method: .get)
            .responseData { (DataResponse) in
                switch DataResponse.result {
                case .success(let data):
                    self.CodeImage.image = UIImage(data: data)
                case .failure(let error):
                    NSLog("\(error.localizedDescription)")
                }
        }
    }
   @objc func Reimage(gesture : UIGestureRecognizer) {
        Alamofire.request("http://i.ancai.cc/StudentPC/Index/CheckCodeImg", method: .get)
            .responseData { (DataResponse) in
                switch DataResponse.result {
                case .success(let data):
                    self.CodeImage.image = UIImage(data: data)
                case .failure(let error):
                    NSLog("\(error.localizedDescription)")

                }
        }
    }
    
    @IBAction func LoginStart(_ sender: AnyObject) {
        Logintool.loginHome(user: username.text!, password: userpass.text!, code: Codetext.text!) { (state) in
            switch state {
            case .学号密码不匹配:
                RKDropdownAlert.title("学号密码不匹配")
            case .学号工号不存在:
                RKDropdownAlert.title("学号工号不存在")
            case .验证码不正确:
                RKDropdownAlert.title("验证码不正确")
            case .网络不稳定:
                RKDropdownAlert.title("无法访问网络", message: "与服务器断开连接 请检查你的网络或 检查是否能够访问 i.ancai.cc")

            case .成功:
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
                
                for (_,i) in HTTPCookieStorage.shared.cookies!.enumerated() {
                    if i.name == "puuser_key" {
                        UserDefaults.standard.set(i.value, forKey: "Cookies")
                    }
                }
                UserDefaults.standard.set(self.username.text, forKey: "Username")
                UserDefaults.standard.set(self.userpass.text, forKey: "Password")
                self.present(vc, animated: true, completion: {
                    NSLog("转场")
                })

            
            }
        }


        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
