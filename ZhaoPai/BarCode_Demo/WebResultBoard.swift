//
//  WebResultBoard.swift
//  BarCode_Demo
//
//  Created by 章韬 on 15/11/3.
//  Copyright © 2015年 章韬. All rights reserved.
//

import Foundation
import UIKit

class WebResultBoard: UIViewController {
    
    class func shareInstance() -> WebResultBoard {
        struct SingletonStruct {
            static var predicate: dispatch_once_t = 0
            static var instance: WebResultBoard? = nil
        }
        dispatch_once(&SingletonStruct.predicate, {
            SingletonStruct.instance = WebResultBoard()
        })
        return SingletonStruct.instance!
    }
    
    init () {
        webRequest = ""
        super.init(nibName: nil, bundle: nil)
        view = UIWebView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var webRequest: String {
        didSet {
            guard oldValue != webRequest else {
                return
            }
            guard let webVew = view as? UIWebView, actURL = NSURL(string: webRequest) else {
                return
            }
            webVew.loadRequest(NSURLRequest(URL: actURL))
        }
    }
}
