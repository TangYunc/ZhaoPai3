//
//  iTVDataFetcher.swift
//  Demo_Swift_Bee
//
//  Created by 章韬 on 15/7/16.
//  Copyright © 2015年 章韬. All rights reserved.
//

import Foundation

class DataFetcher {

    //var allResults = [String: [String: AnyObject]]()
    private let hostSever: NSString = "http://webapi.chinatrace.org/api"
    
     class func shareInstance() -> DataFetcher {
        struct SingletonStruct {
            static var predicate: dispatch_once_t = 0
            static var instance: DataFetcher? = nil
        }
        dispatch_once(&SingletonStruct.predicate, {
            SingletonStruct.instance = DataFetcher()
            }
        )
        return SingletonStruct.instance!
    }
    
     func fetchData(urlStr: String, completionHandler fHandl:(NSData?, NSURLResponse?, NSError?) -> Void) {
        let actURL = hostSever.stringByAppendingPathComponent(urlStr)
        let taskPr = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue:NSOperationQueue.mainQueue())
        taskPr.dataTaskWithRequest(NSURLRequest(URL: NSURL(string: actURL)!), completionHandler: fHandl).resume()
    }
    
     func fetchData(urlStr: String, postData psData: NSData?, completionHandler fHandl:(NSData?, NSURLResponse?, NSError?) -> Void) {
        let actURL = hostSever.stringByAppendingPathComponent(urlStr)
        let urlReq = NSMutableURLRequest(URL: NSURL(string: actURL)!/*, cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: NSTimeInterval(2.0)*/)
        urlReq.HTTPMethod = "POST"
        urlReq.HTTPBody = psData
        let taskPr = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue:NSOperationQueue.mainQueue())
        taskPr.dataTaskWithRequest(urlReq, completionHandler: fHandl).resume()
    }
}

