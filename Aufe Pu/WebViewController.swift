//
//  WebViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/20.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate{
    var webID : String = ""
    var webview : WKWebView!
    var Webtitle : String = ""
    var cookieDomain = "i.ancai.cc"
    var cookieKey = "puuser_key"
    var cookieValue = "Value"
    var cookiePath = "/"
    var cookieVersion = 0
    var progBar = UIProgressView()

    var webConfig:WKWebViewConfiguration {
        get {
            // Create WKWebViewConfiguration instance
            let webCfg:WKWebViewConfiguration = WKWebViewConfiguration()
            
            // Setup WKUserContentController instance for injecting user script
            let userController:WKUserContentController = WKUserContentController()
            
            // JavaScript to attach cookies to document
            let cookieScript = WKUserScript(source: "document.cookie= '\(cookieKey)=\(cookieValue))'", injectionTime:.atDocumentStart, forMainFrameOnly: false)
            
            userController.addUserScript(cookieScript)
            
            // Configure the WKWebViewConfiguration instance with the WKUserContentController
            webCfg.userContentController = userController;
            return webCfg;
        }
        
        
    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        let data = navigationAction.request.url?.absoluteString
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Webtitle
        print(UserDefaults.standard.object(forKey: "Cookies") as! String )
        cookieValue = UserDefaults.standard.object(forKey: "Cookies") as! String
        webview = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), configuration: webConfig)
        webview.navigationDelegate = self
        self.view.addSubview(webview)
        NSLog("\(cookieValue)")
        // Do any additional setup after loading the view.
        if let url = NSURL(string: "http://i.ancai.cc\(webID)") {
            let request = NSMutableURLRequest(url: url as URL)
//            setupCookies()
            request.addValue("\(cookieKey)=\(cookieValue)", forHTTPHeaderField: "Cookie")
            self.webview.load(request as URLRequest)
        }
        progBar = UIProgressView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.frame.width, height: 30))
        progBar.progress = 0.0
        progBar.tintColor = UIColor.red
        self.webview.addSubview(progBar)
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)

    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "var el = document.getElementsByTagName(\"header\")[0]; if (el) el.parentNode.removeChild(el);"
        webView.evaluateJavaScript(js) { (response, error) in
            print(error)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(webview.estimatedProgress), animated: true)
            //进度条的值最大为1.0
            if(self.webview.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                    self.progBar.alpha = 0.0
                    }, completion: { (finished:Bool) -> Void in
                        self.progBar.progress = 0
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCookies(){
        let oneYearInSeconds = TimeInterval(60 * 60 * 24 * 365)
        let cookieProps = [
            // If the domain does not start with a dot, then the cookie is only sent to the exact host specified by the domain.
            HTTPCookiePropertyKey.domain : ".\(cookieDomain)",
            HTTPCookiePropertyKey.path: cookiePath,
            HTTPCookiePropertyKey.name: cookieKey,
            HTTPCookiePropertyKey.value: cookieValue,
            HTTPCookiePropertyKey.version : cookieVersion,
            HTTPCookiePropertyKey.expires: NSDate(timeIntervalSinceNow: oneYearInSeconds)
        ] as [HTTPCookiePropertyKey : Any]
        
        if let appCookie = HTTPCookie.init(properties: cookieProps) {
            HTTPCookieStorage.shared.setCookie(appCookie)
        }
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        
        
    }

}
