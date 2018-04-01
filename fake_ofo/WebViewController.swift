//
//  WebViewController.swift
//  fake_ofo
//
//  Created by YUTONG WU on 2018/3/30.
//  Copyright © 2018年 Big. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

  var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.title = "这就是个浏览器"
        webView = WKWebView(frame: self.view.frame)
        view.addSubview(webView)
        let url = URL(string: "http://www.google.jp")!
        let request = URLRequest(url: url)
      
        webView.load(request)
      
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
