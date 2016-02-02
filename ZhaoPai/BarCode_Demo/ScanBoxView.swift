//
//  ScanBoxView.swift
//  BarCode_Demo
//
//  Created by 章韬 on 15/11/4.
//  Copyright © 2015年 章韬. All rights reserved.
//

import Foundation
import UIKit

class ScanBoxView: UIView {
    
    static let DRAWD_NOTIFICATION = "Self_Drawed"

    //private var scanTimer : NSTimer? = nil
    private var SCAN_LINE_TAG = 0
    private var shapeValues = CGRect(x: 0, y: 0.5, width: 0, height: 0)
    private var pWindowRect = CGRectZero
    private var linMoveDown: CGFloat = 1

    class func shareInstance() -> ScanBoxView {
        struct SingletonStruct {
            static var predicate: dispatch_once_t = 0
            static var instance: ScanBoxView? = nil
        }
        dispatch_once(&SingletonStruct.predicate, {
            SingletonStruct.instance = ScanBoxView(frame: CGRectZero)
        })
        return SingletonStruct.instance!
    }

    override init(frame vFrame: CGRect) {
        inScaning = false
        UIView.setAnimationsEnabled(false)
        super.init(frame: vFrame)
        clearsContextBeforeDrawing = false
        backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)//UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onFinishedReDraw:", name: ScanBoxView.DRAWD_NOTIFICATION, object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var boxSize: CGFloat {
        get {
            guard !CGSizeEqualToSize(shapeValues.size, bounds.size) else {
                return shapeValues.origin.x
            }
            
            pWindowRect = CGRectZero
            shapeValues.size = bounds.size
            shapeValues.origin.x = round(min(bounds.size.width, bounds.size.height)*0.8)
            return shapeValues.origin.x
        }
    }
    
    var windowRect: CGRect {
        get {
            guard CGRectIsEmpty(pWindowRect) else {
                return pWindowRect
            }
            
            let boxSiz = boxSize
            pWindowRect =  CGRect(x: (bounds.size.width - boxSiz)*0.5, y: (bounds.size.height - boxSiz)*0.5, width: boxSiz, height: boxSiz)
            return pWindowRect
        }
    }
    
    var inScaning: Bool {
        willSet {
            guard newValue != inScaning && !newValue else {
                return
            }
            UIView.setAnimationsEnabled(false)
            shapeValues.origin.y = 0.5
            if let scanLn = viewWithTag(SCAN_LINE_TAG) as? UIImageView {
                if 0 != shapeValues.origin.x {
                    shapeValues.origin.y = min(max((scanLn.frame.origin.y - (shapeValues.size.height-shapeValues.origin.x)*0.5)/(shapeValues.origin.x-scanLn.frame.size.height), 0), 1)
                }
            }
        }
        didSet {
            guard oldValue != inScaning && inScaning else {
                return
            }
            setNeedsDisplay()
        }
    }
    
    func restartScan() {
        inScaning = false
        inScaning = true
    }

    override func drawRect(dwRect: CGRect) {
        guard !CGRectIsEmpty(dwRect) else {
            return
        }

        struct TimeReduceStruct {
            static var firstLoad: NSString = ""
        }
        
        let newSgl = "\(dwRect.origin.x).\(dwRect.origin.y).\(dwRect.size.width).\(dwRect.size.height)"
        guard newSgl != TimeReduceStruct.firstLoad || !UIView.areAnimationsEnabled() else {
            NSNotificationCenter.defaultCenter().postNotificationName(ScanBoxView.DRAWD_NOTIFICATION, object: nil)
            return
        }
        TimeReduceStruct.firstLoad = newSgl

        super.drawRect(dwRect)
        
        guard let cntext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let boxSiz = boxSize
        var yPosit = (bounds.size.height - boxSiz)*0.5, xPosit = (bounds.size.width - boxSiz)*0.5
        CGContextClearRect(cntext, CGRectIntersection(dwRect, CGRect(x: xPosit, y: yPosit, width: boxSiz, height: boxSiz)))

        let cBdLen = round(boxSiz*0.1), cBdWid = min(5, round(cBdLen/4))
        CGContextMoveToPoint(cntext, xPosit, yPosit+cBdLen)
        CGContextAddLineToPoint(cntext, xPosit, yPosit)
        CGContextAddLineToPoint(cntext, xPosit+cBdLen, yPosit)
        
        CGContextMoveToPoint(cntext, xPosit+cBdLen, yPosit+boxSiz)
        CGContextAddLineToPoint(cntext, xPosit, yPosit+boxSiz)
        CGContextAddLineToPoint(cntext, xPosit, yPosit+boxSiz-cBdLen)

        xPosit += boxSiz
        CGContextMoveToPoint(cntext, xPosit-cBdLen, yPosit)
        CGContextAddLineToPoint(cntext, xPosit, yPosit)
        CGContextAddLineToPoint(cntext, xPosit, yPosit+cBdLen)
        
        yPosit += boxSiz
        CGContextMoveToPoint(cntext, xPosit, yPosit-cBdLen)
        CGContextAddLineToPoint(cntext, xPosit, yPosit)
        CGContextAddLineToPoint(cntext, xPosit-cBdLen, yPosit)
        
        CGContextSetLineWidth(cntext, cBdWid)
        CGContextSetLineJoin(cntext, CGLineJoin.Miter)
        CGContextSetLineCap(cntext, CGLineCap.Butt)
        CGContextSetStrokeColorWithColor(cntext, UIColor.greenColor().CGColor)
        
        CGContextStrokePath(cntext)
        
        UIView.setAnimationsEnabled(false)
        NSNotificationCenter.defaultCenter().postNotificationName(ScanBoxView.DRAWD_NOTIFICATION, object: nil)
    }
    
    func onFinishedReDraw(sender: NSNotification) {
        guard ScanBoxView.DRAWD_NOTIFICATION == sender.name && inScaning && !UIView.areAnimationsEnabled() else {
            return
        }
        startScan()
        
    }
    
    private func prepareScan() {
        var lnImgV: UIImageView? = nil
        if let scanLn = viewWithTag(SCAN_LINE_TAG) as? UIImageView {
            lnImgV = scanLn
        }
        else {
            lnImgV = UIImageView()
            SCAN_LINE_TAG = lnImgV!.hashValue
            lnImgV!.tag = SCAN_LINE_TAG
            lnImgV!.backgroundColor = UIColor.clearColor()
            self.addSubview(lnImgV!)
            shapeValues.origin.y = 0.5
            linMoveDown = 1
        }
        let boxSiz = boxSize, linPos = CGPoint(x: (bounds.size.width-boxSiz)*0.5, y: (bounds.size.height-boxSiz)*0.5+(boxSiz-lnImgV!.frame.size.height)*shapeValues.origin.y)
        guard lnImgV!.frame.size.width != boxSiz else {
            lnImgV!.frame.origin = linPos
            return
        }
        
        let cBdWid = min(5, max(round(boxSiz*0.025), 3))
        var imgSiz = CGSize(width: boxSiz, height: cBdWid)
        if let linImg = UIImage(named: "scan_line.png") {
            let sclVal = boxSiz/linImg.size.width
            imgSiz = CGSize(width: boxSiz, height: linImg.size.height*sclVal)
            lnImgV!.image = linImg.imageScalingToSize(imgSiz)
        }
        else {
            lnImgV!.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.8)
        }

        lnImgV!.frame = CGRect(origin: linPos, size: imgSiz)

    }

    private func startScan() {
        guard !UIView.areAnimationsEnabled() else {
            return
        }
        prepareScan()
        guard let scanLn = viewWithTag(SCAN_LINE_TAG) as? UIImageView else {
            return
        }
        let boxSiz = boxSize
        guard boxSiz > scanLn.frame.size.height else {
            return
        }
        let posRng = ((bounds.size.height-boxSiz)*0.5, (bounds.size.height+boxSiz)*0.5-scanLn.frame.size.height), offstY = linMoveDown > 0 ? posRng.1-scanLn.frame.origin.y : posRng.0-scanLn.frame.origin.y, timNed = (offstY != 0) ? abs(2.0*Double(offstY/(boxSiz-scanLn.frame.size.height))) : 0

        UIView.setAnimationsEnabled(true)
        UIView.setAnimationRepeatCount(1)
        guard timNed > 0 else {
            linMoveDown = -linMoveDown
            UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: doScan, completion:repeatScan)
            return
        }

        UIView.animateWithDuration(timNed, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {scanLn.frame = CGRectOffset(scanLn.frame, 0, offstY)}, completion:repeatScan)
    }

    private func doScan() {
        guard let scanLn = viewWithTag(SCAN_LINE_TAG) as? UIImageView else {
            return
        }
        let offstY = (boxSize - scanLn.frame.size.height)*linMoveDown
        scanLn.frame = CGRectOffset(scanLn.frame, 0, offstY)

    }

    func animationDidStop(animID: NSString?, finished finiXd: NSNumber?, context cnText: CGContextRef) {
        guard "Scan.Repeat" == animID && (nil == finiXd || finiXd!.boolValue) else {
            return
        }
        repeatScan()
    }

    private func repeatScan(finixd: Bool = true) {
        linMoveDown = -linMoveDown
        UIView.beginAnimations("Scan.Repeat", context:nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(2)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationRepeatCount(1)
        doScan()
        UIView.commitAnimations()
    }
}