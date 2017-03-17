//
//  WKWebViewVC.swift
//  WebKitDemo
//
//  Created by zhangbinbin on 2017/3/12.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

import UIKit
import WebKit //需要添加WebKit.framework

class WKWebViewVC: UIViewController, WKNavigationDelegate {

    var webWiew:WKWebView!
    
    // 自定义的构造器
    init(_ coder: NSCoder? = nil) {
        
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
        
        self.webWiew = WKWebView(frame:CGRect.zero)
        self.webWiew.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("deinit")
        
        webWiew.removeObserver(self, forKeyPath: "loading")
        webWiew.removeObserver(self, forKeyPath: "title")
        webWiew.navigationDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellow
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "back",
                                                                style: UIBarButtonItemStyle.plain,
                                                                target: self,
                                                                action: #selector(WKWebViewVC.leftBariButtonItemClick(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "forward",
                                                                 style: UIBarButtonItemStyle.plain,
                                                                 target: self,
                                                                 action: #selector(WKWebViewVC.rightBariButtonItemClick(_:)))
        
        self.webWiew = WKWebView(frame:UIScreen.main.bounds)
        self.webWiew.navigationDelegate = self
        
        //add webview
        view.addSubview(webWiew!)
        
        // 检测webView对象属性的变化
        webWiew.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webWiew.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        //加载网页
        let request = NSURLRequest(url: NSURL(string: "https://github.com/zhangbinbin5335/ZoomImageViewDemo")! as URL)
        webWiew.load(request as URLRequest)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if(keyPath == "loading"){
            
            if(webWiew.isLoading){
                
                title = "loading"
            }
            
            if let objectTemp = object {
                //                print("loading,\(objectTemp)")
            }
        }
        
        if(keyPath == "title"){
            
            title = webWiew.title
            if let objectTemp = object {
                //                print("title,\(objectTemp)")
            }
        }
    }
    
    func leftBariButtonItemClick(_ item:(UIBarButtonSystemItem)) -> Void {
        if(webWiew.canGoBack){
            
            webWiew.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func rightBariButtonItemClick(_ item:(UIBarButtonSystemItem)) -> Void {
        if(webWiew.canGoForward){
            
            webWiew.goForward()
        }
    }
    
    
    //
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView backList \(webWiew.backForwardList.backList)\n forwardList\(webWiew.backForwardList.forwardList)")
        print("webView did finish navigation")
    }
}
