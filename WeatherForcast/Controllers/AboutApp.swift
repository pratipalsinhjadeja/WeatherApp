//
//  AboutApp.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit
import WebKit

class AboutApp: UIViewController {
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.frame  = CGRect(origin: self.view.frame.origin, size: self.view.bounds.size)
    }
    
    func setupViews() {
        self.title = Texts.WeatherForcast
        let btnClose =  Helper.barButtonItem(selector: #selector(self.btnCloseTapped), controller: self, image: UIImage(named: "close")!)
        self.navigationItem.leftBarButtonItem = btnClose

        self.webView.frame = CGRect.zero
        self.view.addSubview(self.webView)
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "AboutApp", ofType: "html") else {
            fatalError("AboutApp.html not found")
        }
        let url = URL(fileURLWithPath: pathString)
        self.webView.loadFileURL(url, allowingReadAccessTo: url)
    }
    
    @objc func btnCloseTapped(){
        self.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
