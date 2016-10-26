//
//  UserUIViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/20.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import YYWebImage
import YYImage
import Alamofire
import Ji
import AVFoundation
import Photos
import RKDropdownAlert
class UserUIViewController: UIViewController ,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    static var userimageback : UIImageView!
    @IBOutlet weak var TableBackView: UIView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var BackImage: UIImageView!
    @IBOutlet weak var Username: UILabel!
    var imageurl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        regImage()
        parseUser()
        UserImage.clipsToBounds = true
        TableBackView.layer.cornerRadius = 5
        TableBackView.layer.masksToBounds = true
        self.view.backgroundColor = UIColor(colorLiteralRed: 232/255, green: 229/255, blue: 220/255, alpha: 0.8)
        

    }
    @IBAction func previewcom(_ sender: AnyObject) {
        self.navigationController?.pushViewController(MyCodeViewController(), animated: true)
    }
    func parseUser()  {
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
        Alamofire.request("http://i.ancai.cc/Studentwx/")
            .validate()
                .responseString { (DataResponse) in
                    switch DataResponse.result {
                    case .success(let data):
                        let Jidoc = Ji(htmlString: data)
                        let imagebackurl = Jidoc?.rootNode?.firstDescendantWithName("img")?["src"]
                        let staestyle = Jidoc?.rootNode?.descendantsWithAttributeName("class", attributeValue: "mui-navigate-right").count
                        let Loginusername = Jidoc?.rootNode?.xPath("//div[@class='login_name']").first?.content?.trim()
                        self.Username.text = Loginusername

                        if imagebackurl?.range(of: "UserImg")?.isEmpty == false{
                        self.UserImage.yy_setImage(with: NSURL(string:"http://i.ancai.cc\(imagebackurl!)") as URL?, options: YYWebImageOptions.progressiveBlur)
                            
                        }else{
                            if (data.range(of: "StudentWX/Open/Login")?.isEmpty)! == false {

                                self.loginview()
                                
                            }else{
                            RKDropdownAlert.title("获取失败", message: "网络不通畅  请刷新后再试")
                            }
                        
                        }
                        if data.range(of: "http://i.ancai.cc/Content/StudentPC/Images/Student/photo.jpg")?.isEmpty == false {
                        RKDropdownAlert.title("发现问题", message: "你还没有上传头像  请尽快上传 否则无法进行签到 ")
                        
                        }
                        var rightBarButtonItems: [UIBarButtonItem] = []
                        if staestyle == 7 {

                            rightBarButtonItems.append(UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(self.preview)))
                            rightBarButtonItems.append(UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(self.WEBpush)))
                            rightBarButtonItems[0].image = UIImage(named: "scan")
                            rightBarButtonItems[1].image = UIImage(named: "个性")
                            self.navigationItem.rightBarButtonItems = rightBarButtonItems
                        }
                        self.UserImage.layer.cornerRadius = 30
                        self.UserImage.layer.masksToBounds = true
                    case .failure(let error):
                        print(error.localizedDescription)
                    
                    }
        }
            }}
    }
    
    func WEBpush() {
        self.performSegue(withIdentifier: "UserHome", sender: self)
    }
    func regImage()  {
        UserImage.kt_addCorner(radius: UserImage.bounds.width/2)
        BackImage.frame = UserImage.frame
        BackImage.layer.cornerRadius = 5
        BackImage.layer.masksToBounds = true
        let blurEffect = UIBlurEffect(style:.light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.6
        visualEffectView.frame = BackImage.bounds
        BackImage.addSubview(visualEffectView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        UserImage.isUserInteractionEnabled = true
        UserImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editHeadImgButton(_:))))
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editHeadImgButton(_ sender: AnyObject) {
        
        let actionSheet = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册选取")
        
        actionSheet.show(in: self.view)
    }
    //选择进入相册或拍照
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1 {
            
            self.takePhoto()
            
        } else if buttonIndex == 2 {
            
            self.infoImage()
            
        }
    }
    func preview() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActivityManage")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserHome"{
            let vc = segue.destination as! WebViewController
            vc.webID = "/StudentWX/User/OrganizeManage"
            vc.Webtitle = "学生组织管理"
        }
    }
    //从相册
    func infoImage() {
        //判断有无打开相册的权限
        if self.PhotoLibraryPermissions() {
            
            let imagePicker = UIImagePickerController.init()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            imagePicker.allowsEditing = true
            
            //进入相册
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
            
        } else {
            UIAlertView.init(title: "提示", message: "请在设置中打开相册权限", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    func takePhoto() {
        //判断有无打开照相机的权限
        if self.cameraPermissions() {
            
            let imagePicker = UIImagePickerController.init()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            imagePicker.allowsEditing = true
            
            //打开照相机
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        } else {
            UIAlertView.init(title: "提示", message: "请在设置中打开摄像头权限", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    //判断相机访问权限
    func cameraPermissions() -> Bool{
        //AVAuthorizationStatus
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        } else {
            return true
        }
    }
    
    //判断相册访问权限
    func PhotoLibraryPermissions() -> Bool {
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info["UIImagePickerControllerEditedImage"] as! UIImage
        
        //如果是拍照的图片
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        //这就是你要的图片
        saveImage(currentImage: image, imageName: "iconImageFileName.png")
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("iconImageFileName.png")
        updateimage(file:NSURL(fileURLWithPath: fullPath) as URL)
        self.dismiss(animated: true, completion: nil)
    }
    func saveImage(currentImage:UIImage,imageName:String){
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)! as NSData
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(imageName)
        // 将图片写入文件
        imageData.write(toFile: fullPath, atomically: false)
    }
    func updateimage(file:URL)  {
        //NSURL(string: "http://i.ancai.cc/StudentPC/UserCenter/MyInfo") as! URLConvertible
        //headImg
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(file, withName: "headImg")
            }, to: "http://i.ancai.cc/StudentPC/UserCenter/MyInfo", method: HTTPMethod.post, headers: nil,
               encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        guard response.result.value?.range(of: "爱安财-大学生成长服务平台后台") == nil else{
                        RKDropdownAlert.title("修改成功")
                        self.parseUser()
                        return
                        }
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    //登陆
    func loginview()  {
        RKDropdownAlert.title("请输入验证码", message: "检测到你已离线 请输入验证码重新登陆")
        JXTAlertView.shared().show(confirmAction: { (text) in
            let Defaultsdata = UserDefaults.standard
            
            Logintool.loginHome(user:Defaultsdata.object(forKey: "Username") as! String , password: Defaultsdata.object(forKey: "Password") as! String, code: text!, comreturn: { (Loginstate) in
                switch Loginstate{
                case .成功:
                    RKDropdownAlert.title("登陆成功", message: "")

                    self.parseUser()
                case .验证码不正确:
                    self.loginview()
                case .学号密码不匹配:
                    RKDropdownAlert.title("登陆失败", message: "检测到账号密码登陆失败 请退出重新登陆")
                case .学号工号不存在:
                    RKDropdownAlert.title("登陆失败", message: "检测到账号无法登陆 请重新登陆")
                case .网络不稳定:
                    RKDropdownAlert.title("网络错误", message: "网络错误 无法登陆")
                }
            })
            }, andReloadAction: {
                Logintool.regimage(comreturn: { (imagedata) in
                    JXTAlertView.shared().refreshVerifyImage(UIImage(data: imagedata))
                })
        })
    }

}
extension UIImage {
    func kt_drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return output!
    }

}
extension UIImageView {
    /**
     / !!!只有当 imageView 不为nil 时，调用此方法才有效果
     
     :param: radius 圆角半径
     */
     func kt_addCorner(radius: CGFloat) {
        self.image = self.image?.kt_drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
}



