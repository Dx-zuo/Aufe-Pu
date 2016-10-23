//
//  LoginTool.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/23.
//  Copyright © 2016年 Dx. All rights reserved.
//

import Foundation
import Ji
import Alamofire
class Logintool {
    static func loginHome(user:String,password:String,code:String,comreturn:@escaping (_ state:Loginstate)->()) {
        let parameters = [
            "userName" : user,
            "password" : password,
            "checkCode": code
            ] as [String : Any]
        Alamofire.request("http://i.ancai.cc/", method: .post,parameters:parameters)
            .responseString { (DataResponse) in
                switch DataResponse.result{
                case .success(let data):
                    guard data.range(of: "验证码不正确") == nil else{
                        comreturn(Loginstate.验证码不正确)
                        return
                    }
                    guard data.range(of: "学号密码不匹配") == nil else{
                        comreturn(Loginstate.学号密码不匹配)
                        return
                    }
                    guard data.range(of: "学号/工号不存在") == nil else{
                        comreturn(Loginstate.学号工号不存在)
                        return
                    }
                    comreturn(Loginstate.成功)

                case .failure(_):
                    comreturn(Loginstate.网络不稳定)
                }
        }

    }
    static func regimage(comreturn:@escaping (_ Data:Data)->()){
        Alamofire.request("http://i.ancai.cc/StudentPC/Index/CheckCodeImg", method: .get)
            .responseData { (DataResponse) in
                switch DataResponse.result {
                case .success(let data):
                    comreturn(data)
                case .failure(let error):
                    NSLog("\(error.localizedDescription)")
                }
        }
    
    }
}
enum Loginstate {
    case 成功
    case 验证码不正确
    case 学号密码不匹配
    case 学号工号不存在
    case 网络不稳定
}
