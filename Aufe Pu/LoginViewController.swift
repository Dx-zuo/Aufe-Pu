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
import MBProgressHUD
class LoginViewController: UIViewController {
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userpass: UITextField!
    @IBOutlet weak var Codetext: UITextField!
    @IBOutlet weak var CodeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ///LoginButton
        LoginButton.layer.cornerRadius = 8
        LoginButton.layer.masksToBounds = true
        //username
        
        username.frame.size.height = 45
        username.leftView = UIImageView(image: UIImage(named: "用户"))
        username.leftViewMode = .always
        username.layer.cornerRadius = 8
        username.layer.masksToBounds = true
        
        //userpass

        userpass.isSecureTextEntry = true
        userpass.frame.size.height = 45
        userpass.leftView = UIImageView(image: UIImage(named: "密码"))
        userpass.leftViewMode = .always
        userpass.layer.cornerRadius = 8
        userpass.layer.masksToBounds = true
        //view
        CodeImage.isUserInteractionEnabled = true
        CodeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Reimage)))

        //
        yzmini()
    }
    func yzmini() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        hud.label.text = "正在登录中"
        hud.animationType = .fade
        Alamofire.request("http://i.ancai.cc/StudentPC/Index/CheckCodeImg", method: .get)
            .responseData { (DataResponse) in
                switch DataResponse.result {
                case .success(let data):
                    hud.hide(animated: false)

                    self.CodeImage.image = UIImage(data: data)
                case .failure(let error):
                    hud.hide(animated: false)
                    RKDropdownAlert.title("", message: "网络错误无法访问网页")
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
