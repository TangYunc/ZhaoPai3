//
//  ResultBoard.swift
//  BarCode_Demo
//
//  Created by 章韬 on 15/11/3.
//  Copyright © 2015年 章韬. All rights reserved.
//

import Foundation
import UIKit

class ResultBoard: UIViewController, UITextViewDelegate {
    
    //static let NOTIFY_QUERY_RESULT = "QUERY_RESULT"
    private let urlRegular = "((http|https)://)?(([a-z0-9\\._-]+\\.[a-z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-z0-9\\&%_\\./-~-]*)?"
    private let mailReglar = "(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3})+)"
    
    class func shareInstance() -> ResultBoard {
        struct SingletonStruct {
            static var predicate: dispatch_once_t = 0
            static var instance: ResultBoard? = nil
        }
        dispatch_once(&SingletonStruct.predicate, {
            SingletonStruct.instance = ResultBoard()
        })
        return SingletonStruct.instance!
    }
    
    init () {
        codeCaptured = ""
        super.init(nibName: nil, bundle: nil)
        view = UITextView()
        if let textVw = view as? UITextView {
            textVw.font = UIFont.systemFontOfSize(12)
            textVw.delegate = self
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*override func viewDidAppear(animtD: Bool) {
        super.viewDidAppear(animtD)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onFinishedQuery:", name: ResultBoard.NOTIFY_QUERY_RESULT, object: nil)
    }
    
    override func viewWillDisappear(animtD: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ResultBoard.NOTIFY_QUERY_RESULT, object: nil)
        //NSNotificationQueue.defaultQueue().dequeueNotificationsMatching(NSNotification(name: ResultBoard.NOTIFY_QUERY_RESULT, object: nil), coalesceMask: Int(NSNotificationCoalescing.CoalescingOnName.rawValue))
        super.viewWillDisappear(animtD)
    }*/

    var codeCaptured: String {
        didSet {
            guard oldValue != codeCaptured else {
                return
            }
            guard let textVw = view as? UITextView else {
                return
            }
            let oriStr = "Code = " + codeCaptured as NSString, xowStr = NSMutableAttributedString(string: oriStr as String)
            xowStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.greenColor()], range: NSMakeRange(0, 7))
            xowStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.orangeColor()], range: NSMakeRange(7, oriStr.length-7))
            markURLorEMail(xowStr)

            if let _ = codeCaptured.rangeOfString("^[0-9]+$", options: NSStringCompareOptions.RegularExpressionSearch) {
                xowStr.appendAttributedString(NSAttributedString(string: "\nQuerying...Wait Please...", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.redColor()]))
                textVw.attributedText = xowStr
                DataFetcher.shareInstance().fetchData("getProductData?productCode="+codeCaptured, completionHandler: onDataGot)
            }
            else if let _ = codeCaptured.rangeOfString("(?<=[0-9a-z])://(?=[0-9a-z])", options: NSStringCompareOptions(rawValue: NSStringCompareOptions.RegularExpressionSearch.rawValue | NSStringCompareOptions.CaseInsensitiveSearch.rawValue)), actURL = NSURL(string: codeCaptured) {
                textVw.attributedText = xowStr
                if UIApplication.sharedApplication().canOpenURL(actURL) {
                    UIApplication.sharedApplication().openURL(actURL)
                }
                if codeCaptured.hasSuffix("/BarCode_Demo.plist") {
                    exitApplication()
                }
            }
            else {
                textVw.attributedText = xowStr
            }
        }
    }
    
    private func markURLorEMail(iptStr: NSMutableAttributedString) {
        let oriStr = iptStr.string as NSString
        guard oriStr.length > 0 else {
            return
        }
        var urlRng = NSRange(location: 0, length: oriStr.length)
        while urlRng.length > 0 {
            urlRng = oriStr.rangeOfString(urlRegular, options: NSStringCompareOptions(rawValue: NSStringCompareOptions.RegularExpressionSearch.rawValue | NSStringCompareOptions.CaseInsensitiveSearch.rawValue), range: urlRng)
            guard urlRng.length > 0 else {
                break
            }
            iptStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSUnderlineStyleAttributeName: 1, NSForegroundColorAttributeName: UIColor.purpleColor()], range: urlRng)
            urlRng.location += urlRng.length
            urlRng.length = oriStr.length - urlRng.location
        }
        urlRng = NSRange(location: 0, length: oriStr.length)
        while urlRng.length > 0 {
            urlRng = oriStr.rangeOfString(mailReglar, options: NSStringCompareOptions(rawValue: NSStringCompareOptions.RegularExpressionSearch.rawValue | NSStringCompareOptions.CaseInsensitiveSearch.rawValue), range: urlRng)
            guard urlRng.length > 0 else {
                break
            }
            iptStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSUnderlineStyleAttributeName: 1, NSForegroundColorAttributeName: UIColor.brownColor()], range: urlRng)
            urlRng.location += urlRng.length
            urlRng.length = oriStr.length - urlRng.location
        }
    }
    
    internal func onDataGot(dataGt: NSData?, urlRsp: NSURLResponse?, errMsg: NSError?) {
        guard let httRsp = urlRsp as? NSHTTPURLResponse else {
            return
        }
        
        guard errMsg == nil else {
            finishedQuery(errMsg)
            //NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: ResultBoard.NOTIFY_QUERY_RESULT, object: errMsg), postingStyle: NSPostingStyle.PostASAP)
            //NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_QUERY_RESULT, object: errMsg)
            return
        }
        guard dataGt != nil && dataGt?.length > 0 else {
            finishedQuery("无数据！")
            //NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: ResultBoard.NOTIFY_QUERY_RESULT, object: "无数据！"), postingStyle: NSPostingStyle.PostASAP)
            //NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_QUERY_RESULT, object: "无数据！")
            return
        }
        guard httRsp.statusCode == 200 else {
            finishedQuery("接口访问错误：\(httRsp.statusCode)！")
            //NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: ResultBoard.NOTIFY_QUERY_RESULT, object: "接口访问错误：\(httRsp.statusCode)！"), postingStyle: NSPostingStyle.PostASAP)
            //NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_QUERY_RESULT, object: "接口访问错误：\(httRsp.statusCode)！")
            return
        }
        
        do {
            let jsnObj = try NSJSONSerialization.JSONObjectWithData(dataGt!, options: NSJSONReadingOptions.MutableLeaves)
            let jsData = try NSJSONSerialization.dataWithJSONObject(jsnObj, options: NSJSONWritingOptions.PrettyPrinted)
            if let jsnStr = String(data: jsData, encoding: NSUTF8StringEncoding) {
                let oriStr = jsnStr.stringByReplacingOccurrencesOfString("[\\n]{2,}", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch).stringByReplacingOccurrencesOfString("\\/", withString: "/") as NSString, xowStr = NSMutableAttributedString(string: oriStr as String, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
                var fndRng = NSMakeRange(0, oriStr.length)
                while fndRng.length > 0 {
                    let mthDRg = oriStr.rangeOfString("[^\\{\\}\\,\\[\\]\\n\\\":]+(?=(\\\")?(\\s)+:)", options: NSStringCompareOptions.RegularExpressionSearch, range: fndRng)
                    guard mthDRg.length > 0 else {
                        break
                    }
                    let endPos = mthDRg.location+mthDRg.length
                    fndRng = NSMakeRange(endPos, oriStr.length-endPos)
                    xowStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.blueColor()], range: mthDRg)
                }
                markURLorEMail(xowStr)
                /*var urlRng = NSRange(location: 0, length: oriStr.length)
                while urlRng.length > 0 {
                    urlRng = oriStr.rangeOfString(urlRegular, options: NSStringCompareOptions(rawValue: NSStringCompareOptions.RegularExpressionSearch.rawValue | NSStringCompareOptions.CaseInsensitiveSearch.rawValue), range: urlRng)
                    guard urlRng.length > 0 else {
                        break
                    }
                    xowStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSUnderlineStyleAttributeName: 1, NSForegroundColorAttributeName: UIColor.purpleColor()], range: urlRng)
                    urlRng.location += urlRng.length
                    urlRng.length = oriStr.length - urlRng.location
                }
                urlRng = NSRange(location: 0, length: oriStr.length)
                while urlRng.length > 0 {
                    urlRng = oriStr.rangeOfString(mailReglar, options: NSStringCompareOptions(rawValue: NSStringCompareOptions.RegularExpressionSearch.rawValue | NSStringCompareOptions.CaseInsensitiveSearch.rawValue), range: urlRng)
                    guard urlRng.length > 0 else {
                        break
                    }
                    xowStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(20), NSUnderlineStyleAttributeName: 1, NSForegroundColorAttributeName: UIColor.brownColor()], range: urlRng)
                    urlRng.location += urlRng.length
                    urlRng.length = oriStr.length - urlRng.location
                }*/
                finishedQuery(xowStr)
                //NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: ResultBoard.NOTIFY_QUERY_RESULT, object: xowStr), postingStyle: NSPostingStyle.PostASAP)
                //NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_QUERY_RESULT, object: xowStr)
            }
        }
        catch {
            let xowStr = NSMutableAttributedString(string: "数据解析错误！", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.redColor()])
            if let strGet = NSString(data: dataGt!, encoding: NSUTF8StringEncoding) {
                xowStr.appendAttributedString(NSAttributedString(string: "\nRawString = ", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.greenColor()]))
                xowStr.appendAttributedString(NSAttributedString(string: strGet as String, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
            }
            finishedQuery(xowStr)
            //NSNotificationQueue.defaultQueue().enqueueNotification(NSNotification(name: ResultBoard.NOTIFY_QUERY_RESULT, object: xowStr), postingStyle: NSPostingStyle.PostASAP)
            //NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_QUERY_RESULT, object: xowStr)
            return
        }
    }
    
    private func finishedQuery(msgGet: NSObject?) {
        guard let textVw = view as? UITextView else {
            return
        }
        
        struct TimeReduceStruct {
            static var firstLoad = 0
        }
        guard let haxVal = msgGet?.hashValue else {
            return
        }
        guard 0 != haxVal && haxVal != TimeReduceStruct.firstLoad else {
            return
        }
        TimeReduceStruct.firstLoad = haxVal
        
        let xowStr = NSMutableAttributedString(attributedString: textVw.attributedText)
        if xowStr.string.hasSuffix("\nQuerying...Wait Please...") {
            xowStr.deleteCharactersInRange(NSMakeRange((xowStr.string as NSString).length-26, 26))
        }
        
        let ledStr = NSAttributedString(string: "\nResult = ", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.greenColor()])
        if let tmpStr = msgGet as? NSAttributedString {
            if tmpStr.length > 0 {
                xowStr.appendAttributedString(ledStr)
                xowStr.appendAttributedString(tmpStr)
            }
        }
        else if let tmpStr = msgGet as? String {
            if !tmpStr.isEmpty {
                xowStr.appendAttributedString(ledStr)
                xowStr.appendAttributedString(NSAttributedString(string: tmpStr, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.redColor()]))
            }
        }
        textVw.attributedText = xowStr
    }

    /*func onFinishedQuery(sender: NSNotification) {
        guard ResultBoard.NOTIFY_QUERY_RESULT == sender.name else {
            return
        }
        guard let textVw = view as? UITextView else {
            return
        }
        
        struct TimeReduceStruct {
            static var firstLoad = 0
        }
        guard let haxVal = sender.object?.hashValue else {
            return
        }
        guard 0 != haxVal && haxVal != TimeReduceStruct.firstLoad else {
            return
        }
        TimeReduceStruct.firstLoad = haxVal

        let xowStr = NSMutableAttributedString(attributedString: textVw.attributedText)
        if xowStr.string.hasSuffix("\nQuerying...Wait Please...") {
            xowStr.deleteCharactersInRange(NSMakeRange((xowStr.string as NSString).length-26, 26))
        }

        let ledStr = NSAttributedString(string: "\nResult = ", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.greenColor()])
        if let tmpStr = sender.object as? NSAttributedString {
            if tmpStr.length > 0 {
                xowStr.appendAttributedString(ledStr)
                xowStr.appendAttributedString(tmpStr)
            }
        }
        else if let tmpStr = sender.object as? String {
            if !tmpStr.isEmpty {
                xowStr.appendAttributedString(ledStr)
                xowStr.appendAttributedString(NSAttributedString(string: tmpStr, attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.redColor()]))
            }
        }
        textVw.attributedText = xowStr
    }*/

    func textViewShouldBeginEditing(textVw: UITextView) -> Bool {
        return false
    }
    
    func textViewDidChangeSelection(textVw: UITextView) {
        var urlRng = NSRange(location: 0, length: 0), plsRng = NSRange(location: 0, length: 0)
        //let tmpStr = (textVw.attributedText.string as NSString).substringWithRange(tmpRng)
        guard textVw.selectedRange.location < (textVw.attributedText.string as NSString).length else {
            return
        }
        guard let udLNum = textVw.attributedText.attribute(NSUnderlineStyleAttributeName, atIndex: textVw.selectedRange.location, effectiveRange: &urlRng) as? NSNumber else {
            return
        }
        guard udLNum.integerValue != 0 && urlRng.length > 0 else {
            return
        }
        if urlRng.location > 0 {
            while let tmpNum = textVw.attributedText.attribute(NSUnderlineStyleAttributeName, atIndex: urlRng.location-1, effectiveRange: &plsRng) as? NSNumber {
                guard tmpNum.integerValue != 0 && plsRng.length > 0 else {
                    break
                }
                urlRng.length = max(urlRng.location+urlRng.length, plsRng.location+plsRng.length)
                urlRng.location = min(urlRng.location, plsRng.location)
                urlRng.length -= urlRng.location
                guard urlRng.location > 0 else {
                    break
                }
            }
        }
        if urlRng.location+urlRng.length+1 < textVw.attributedText.length {
            while let tmpNum = textVw.attributedText.attribute(NSUnderlineStyleAttributeName, atIndex: urlRng.location+urlRng.length+1, effectiveRange: &plsRng) as? NSNumber {
                guard tmpNum.integerValue != 0 && plsRng.length > 0 else {
                    break
                }
                urlRng.length = max(urlRng.location+urlRng.length, plsRng.location+plsRng.length)
                urlRng.location = min(urlRng.location, plsRng.location)
                urlRng.length -= urlRng.location
                guard urlRng.location+urlRng.length+1 < textVw.attributedText.length else {
                    break
                }
            }
        }

        var urlStr = (textVw.attributedText.string as NSString).substringWithRange(urlRng)
        if let _ = urlStr.rangeOfString("^"+mailReglar+"$", options: NSStringCompareOptions(rawValue: NSStringCompareOptions.RegularExpressionSearch.rawValue | NSStringCompareOptions.CaseInsensitiveSearch.rawValue)) {
            urlStr = "mailto://"+urlStr
        }
        else if let _ = urlStr.rangeOfString("://") {
        }
        else {
            urlStr = "http://"+urlStr
        }
        guard let actURL = NSURL(string: urlStr) else {
            return
        }
        if UIApplication.sharedApplication().canOpenURL(actURL) {
            UIApplication.sharedApplication().openURL(actURL)
        }
    }
    
    internal func exitApplication() {
        if let theApp = UIApplication.sharedApplication().delegate, theWin = theApp.window {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                //theWin!.alpha = 0
                theWin!.frame = CGRect(x: theWin!.bounds.size.width, y: theWin!.bounds.size.height, width: 0, height: 0)
                }, completion:doExit)
        }
        else {
           doExit()
        }
    }
    
    private func doExit(finixd: Bool = true) {
        exit(0)
    }
}
