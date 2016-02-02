//
//  ViewController.swift
//  BarCode_Demo
//
//  Created by 章韬 on 15/11/3.
//  Copyright © 2015年 章韬. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

public let SCAN_RESULT_GET = "CMDI.SCAN_RESULT.GET"
public let VIDEOLAYER_GET = "CMDI.VIDEOLAYER.GET"

class CaptureBoard: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //private let scanQueue = dispatch_queue_create("ScanQueue", nil)
    
    class func shareInstance() -> CaptureBoard {
        struct SingletonStruct {
            static var predicate: dispatch_once_t = 0
            static var instance: CaptureBoard? = nil
        }
        dispatch_once(&SingletonStruct.predicate, {
            SingletonStruct.instance = CaptureBoard()
        })
        return SingletonStruct.instance!
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        videoLayer = AVCaptureVideoPreviewLayer(session: AVCaptureSession())
        guard nil != videoLayer else {
            return
        }
        videoLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.insertSublayer(videoLayer!, atIndex: 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var videoLayer: AVCaptureVideoPreviewLayer? = nil
    private var origOrient: UIInterfaceOrientation = .Unknown
    private var useNotifyM: Bool = false
    private var noRsltView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard nil != videoLayer else {
            return
        }
        
        let capSes = videoLayer!.session
        //高质量采集率
        if capSes.canSetSessionPreset(AVCaptureSessionPresetHigh) {
            capSes.sessionPreset = AVCaptureSessionPresetHigh
        }

        capSes.beginConfiguration()
        do {
            //获取摄像设备
            let capDev = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo),
            //创建输入流
            capIpt = try AVCaptureDeviceInput(device: capDev),
            
            //创建输出流
            capOut = AVCaptureMetadataOutput()
            
            //设置代理 在主线程里刷新
            capOut.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())


            if capSes.canAddInput(capIpt) {
                capSes.addInput(capIpt)
            }
            if capSes.canAddOutput(capOut) {
                capSes.addOutput(capOut)
            }
            
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            capOut.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        }
        catch {
        }
        
        capSes.commitConfiguration()

    }
    
    
    override func viewWillAppear(animtD: Bool) {
        super.viewWillAppear(animtD)
        arrangeView()
        guard nil != videoLayer else {
            return
        }
        
        videoLayer!.session.startRunning()
    }
    
    override func viewWillDisappear(animtD: Bool) {
        super.viewWillDisappear(animtD)
        let bxView = ScanBoxView.shareInstance()
        if bxView.superview == view {
            bxView.inScaning = false
        }
        guard nil != videoLayer else {
            return
        }
         videoLayer!.session.stopRunning()
        //AVCaptureFileOutputDelegate
//            AVCaptureVideoDataOutput
        //发布一个获得videoLayer的通知
        NSNotificationCenter.defaultCenter().postNotificationName(VIDEOLAYER_GET, object: videoLayer);

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        arrangeView()
    }
    
    private var topOffset: CGFloat {
        get {
            guard let nvCtrl = navigationController else {
                return 0
            }
            guard !nvCtrl.navigationBarHidden else {
                return nvCtrl.navigationBar.frame.origin.y
            }
            
            return nvCtrl.navigationBar.frame.origin.y + nvCtrl.navigationBar.frame.size.height
        }
    }
    
    private func rotatePreviewLayer() {
        guard nil != videoLayer else {
            return
        }
        
        switch interfaceOrientation {
        case .PortraitUpsideDown:
            videoLayer!.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI)))
        case .LandscapeLeft:
            videoLayer!.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
        case .LandscapeRight:
            videoLayer!.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(-M_PI_2)))
        default:
            videoLayer!.setAffineTransform(CGAffineTransformIdentity)
        }

        let tpOfst = topOffset, xWdRec = CGRect(x: view.layer.bounds.origin.x, y: view.layer.bounds.origin.y+tpOfst, width: view.layer.bounds.size.width, height: view.layer.bounds.size.height-tpOfst)
        videoLayer!.frame = xWdRec
        videoLayer!.position = CGPoint(x: CGRectGetMidX(videoLayer!.frame), y: CGRectGetMidY(videoLayer!.frame))
    }

    private func arrangeView() {
        guard nil != videoLayer else {
            return
        }

        struct TimeReduceStruct {
            static var firstLoad: NSString = ""
        }
        
        let tpOfst = topOffset, newSgl = "\(view.bounds.size.width).\(view.bounds.size.height).\(tpOfst)", bxView = ScanBoxView.shareInstance()
        guard newSgl != TimeReduceStruct.firstLoad else {
            if bxView.superview == view {
                bxView.restartScan()
            }
            return
        }
        TimeReduceStruct.firstLoad = newSgl
        
        // 预览层
        rotatePreviewLayer()
        
        if bxView.superview != view {
            view.addSubview(bxView)
        }
        bxView.inScaning = false
        bxView.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y+tpOfst, width: view.bounds.size.width, height: view.bounds.size.height-tpOfst)

        let capSes = videoLayer!.session
        
        capSes.beginConfiguration()
        
        //设置扫描范围
        let sWnRec = bxView.windowRect
        for tmpOut in capSes.outputs.reverse() {
            guard let capOut = tmpOut as? AVCaptureMetadataOutput else {
                continue

            }
            capOut.rectOfInterest = CGRectMake(sWnRec.origin.y/videoLayer!.frame.size.height,
                sWnRec.origin.x/videoLayer!.frame.size.width,
                sWnRec.size.height/videoLayer!.frame.size.height,
                sWnRec.size.width/videoLayer!.frame.size.width)
        }

        capSes.commitConfiguration()

        bxView.inScaning = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func setUseNotification(usNtfy: Bool, AndNoResultView noView: Bool) {
        useNotifyM = usNtfy
        noRsltView = noView
    }


    func captureOutput(capOut: AVCaptureOutput!, didOutputMetadataObjects mDObjs: [AnyObject]!, fromConnection cpCnct: AVCaptureConnection! ) {
        guard !mDObjs.isEmpty else {
            return
        }
        
        //capSession.stopRunning()
        guard let codObj = mDObjs[0] as? AVMetadataMachineReadableCodeObject, rslStr = codObj.stringValue, nvCtrl = navigationController else {
            return
        }
        
        if useNotifyM {
            NSNotificationCenter.defaultCenter().postNotificationName(SCAN_RESULT_GET, object:rslStr);
        }
        
        guard !noRsltView else {
            return
        }

        
        let rslBrd = ResultBoard.shareInstance()
        guard nvCtrl.topViewController != rslBrd else {
            return
        }
        if nvCtrl.viewControllers.contains(rslBrd) {
            nvCtrl.popToViewController(rslBrd, animated: true)
        }
        else {
            nvCtrl.pushViewController(rslBrd, animated: true)
        }
        rslBrd.codeCaptured = rslStr
    }
}



