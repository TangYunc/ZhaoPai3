//
//  UIImageExtension.swift
//  Demo_Swift_Bee
//
//  Created by 章韬 on 15/7/2.
//  Copyright © 2015年 章韬. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
import CoreImage


extension UIImage {
    
    convenience init?(Color dColor: UIColor, andSize imgSiz:CGSize) {
        guard imgSiz.width>0.0 && imgSiz.height > 0.0 else {
            return nil
        }
        UIGraphicsBeginImageContext(imgSiz);
        let contxt = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(contxt, dColor.CGColor)
        CGContextFillRect(contxt, CGRect(origin: CGPointZero, size: imgSiz))
        self.init(CGImage: UIGraphicsGetImageFromCurrentImageContext().CGImage!)
        //self = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    class func blurryImage(imagIn:UIImage, var withBlurLevel blurLv:CGFloat) -> UIImage? {
        //模糊度,
        if blurLv < 0.1 || blurLv > 2.0 {
            blurLv = 0.5;
        }
        
        //boxSize必须大于0
        var boxSiz = UInt32(blurLv * 100)
        boxSiz -= (boxSiz % 2) + 1;
        guard boxSiz > 0 else {
            return nil
        }
        
        var imgRef = imagIn.CGImage
        let inProv = CGImageGetDataProvider(imgRef)
        let btData = CGDataProviderCopyData(inProv)
        var inBuff = vImage_Buffer(data: UnsafeMutablePointer<Void>(CFDataGetBytePtr(btData)), height: vImagePixelCount(CGImageGetHeight(imgRef)), width: vImagePixelCount(CGImageGetWidth(imgRef)), rowBytes: CGImageGetBytesPerRow(imgRef))
        let pixBuf = malloc(CGImageGetBytesPerRow(imgRef) * CGImageGetHeight(imgRef));
        var outBuf = vImage_Buffer(data: pixBuf, height: vImagePixelCount(CGImageGetHeight(imgRef)), width: vImagePixelCount(CGImageGetWidth(imgRef)), rowBytes: CGImageGetBytesPerRow(imgRef))
        //var imgErr:vImage_Error
        
        // 第三个中间的缓存区,抗锯齿的效果
        //var pixBf2 = malloc(CGImageGetBytesPerRow(imgRef) * CGImageGetHeight(imgRef));
        /*var outBf2 = vImage_Buffer(data: malloc(CGImageGetBytesPerRow(imgRef) * CGImageGetHeight(imgRef)), height: vImagePixelCount(CGImageGetHeight(imgRef)), width: vImagePixelCount(CGImageGetWidth(imgRef)), rowBytes: CGImageGetBytesPerRow(imgRef))*/
 
        var imgErr = vImageBoxConvolve_ARGB8888(&inBuff, &outBuf, nil, 0, 0, boxSiz, boxSiz, nil, vImage_Flags(kvImageEdgeExtend))
        imgErr = vImageBoxConvolve_ARGB8888(&outBuf, &inBuff, nil, 0, 0, boxSiz, boxSiz, nil, vImage_Flags(kvImageEdgeExtend))
        imgErr = vImageBoxConvolve_ARGB8888(&inBuff, &outBuf, nil, 0, 0, boxSiz, boxSiz, nil, vImage_Flags(kvImageEdgeExtend))
        
        //颜色空间DeviceRGB
        let colorS = CGColorSpaceCreateDeviceRGB();
        //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
        let contex = CGBitmapContextCreate( outBuf.data, Int(outBuf.width), Int(outBuf.height), 8, outBuf.rowBytes, colorS, CGImageGetBitmapInfo(imgRef).rawValue);
        
        //根据上下文，处理过的图片，重新组件
        imgRef = CGBitmapContextCreateImage (contex);
        let oImage = UIImage(CGImage: imgRef!)
        
        //clean up
        //CGContextRelease(contex);
        //CGColorSpaceRelease(colorS);
        
        free(outBuf.data);
        //free(outBf2.data);
        //CFRelease(btData);
        
        //CGColorSpaceRelease(colorS);
        //CGImageRelease(imgRef);
        
        return oImage
    }
    
    func blurImage(WithRadius blurRd:Float, TintColor tColor:UIColor?, SaturationDeltaFactor sDelta:Float, andMaskImage mImage:UIImage? = nil) -> UIImage? {
        guard self.size.width > 1.0 && self.size.height > 1.0 && self.CGImage != nil && (mImage == nil || mImage!.CGImage != nil) else {
            return nil
        }
        
        let imgRec = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        var eImage = self
        let hsBlur = blurRd > 0.0, hsSChg = abs(sDelta-1.0) > 0.0
        
        if hsBlur || hsSChg {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale)
            let eInCtx = UIGraphicsGetCurrentContext()
            CGContextScaleCTM(eInCtx, 1.0, -1.0)
            CGContextTranslateCTM(eInCtx, 0, -self.size.height)
            CGContextDrawImage(eInCtx, imgRec, self.CGImage)
            
            var eInBuf = vImage_Buffer(data: CGBitmapContextGetData(eInCtx), height: vImagePixelCount(CGBitmapContextGetHeight(eInCtx)), width: vImagePixelCount(CGBitmapContextGetWidth(eInCtx)), rowBytes: CGBitmapContextGetBytesPerRow(eInCtx))
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale);
            let  eOutCt = UIGraphicsGetCurrentContext()
            var eOutBf = vImage_Buffer(data: CGBitmapContextGetData(eOutCt), height: vImagePixelCount(CGBitmapContextGetHeight(eOutCt)), width: vImagePixelCount(CGBitmapContextGetWidth(eOutCt)), rowBytes: CGBitmapContextGetBytesPerRow(eOutCt))

            if hsBlur {
                let inRads = blurRd * Float(UIScreen.mainScreen().scale)
                var radVal = UInt32(floor(Double(inRads) * 3.0 * sqrt(2 * M_PI) / 4 + 0.5));
                if radVal % 2 != 1 {
                    radVal += 1; // force radius to be odd so that the three box-blur methodology works.
                }
                vImageBoxConvolve_ARGB8888(&eInBuf, &eOutBf, nil, 0, 0, radVal, radVal, nil, vImage_Flags(kvImageEdgeExtend));
                vImageBoxConvolve_ARGB8888(&eOutBf, &eInBuf, nil, 0, 0, radVal, radVal, nil, vImage_Flags(kvImageEdgeExtend));
                vImageBoxConvolve_ARGB8888(&eInBuf, &eOutBf, nil, 0, 0, radVal, radVal, nil, vImage_Flags(kvImageEdgeExtend));
            }
            
            var bfSwpd = false;
            if hsSChg {
                var fMatrx = [
                    0.0722 + 0.9278 * sDelta,  0.0722 - 0.0722 * sDelta,  0.0722 - 0.0722 * sDelta,  0.0,
                    0.7152 - 0.7152 * sDelta,  0.7152 + 0.2848 * sDelta,  0.7152 - 0.7152 * sDelta,  0.0,
                    0.2126 - 0.2126 * sDelta,  0.2126 - 0.2126 * sDelta,  0.2126 + 0.7873 * sDelta,  0.0,
                    0.0,                       0.0,                       0.0,                       1.0
                ]
                let diviSr:Int32 = 256
                let mtrxSz = fMatrx.count
                var sMatrx = [Int16](count: mtrxSz, repeatedValue: 0)
                for dIndex in 0..<mtrxSz {
                    sMatrx[dIndex] = Int16(roundf(fMatrx[dIndex] * Float(diviSr)));
                }
                if (hsBlur) {
                    vImageMatrixMultiply_ARGB8888(&eOutBf, &eInBuf, sMatrx, diviSr, nil, nil, vImage_Flags(kvImageNoFlags));
                    bfSwpd = true;
                }
                else {
                    vImageMatrixMultiply_ARGB8888(&eInBuf, &eOutBf, sMatrx, diviSr, nil, nil, vImage_Flags(kvImageNoFlags));
                }
            }
            
            if !bfSwpd {
                eImage = UIGraphicsGetImageFromCurrentImageContext();
            }
            
            UIGraphicsEndImageContext();
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.mainScreen().scale);
        let oCntxt = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(oCntxt, 1.0, -1.0);
        CGContextTranslateCTM(oCntxt, 0, -self.size.height);
        
        // Draw base image.
        CGContextDrawImage(oCntxt, imgRec, self.CGImage);
        
        // Draw effect image.
        if (hsBlur) {
            CGContextSaveGState(oCntxt);
            if mImage != nil {
                CGContextClipToMask(oCntxt, imgRec, mImage!.CGImage);
            }
            CGContextDrawImage(oCntxt, imgRec, eImage.CGImage);
            CGContextRestoreGState(oCntxt);
        }
        
        // Add in color tint.
        if tColor != nil {
            CGContextSaveGState(oCntxt);
            CGContextSetFillColorWithColor(oCntxt, tColor!.CGColor);
            CGContextFillRect(oCntxt, imgRec);
            CGContextRestoreGState(oCntxt);
        }
        
        // Output image is ready.
        let oImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return oImage;
    }
    
    func imageCutBy(tgtRec: CGRect) -> UIImage? {
        guard tgtRec.size.width > 0.0 && tgtRec.size.height > 0.0 else {
            return nil
        }
        guard tgtRec.origin != CGPointZero || tgtRec.size.width + tgtRec.origin.x <= self.size.width || tgtRec.size.height + tgtRec.origin.y <= self.size.height else {
            return self
        }
        
        let tgtSiz = CGSize(width: min(tgtRec.size.width, (self.size.width - tgtRec.origin.x)), height: min(tgtRec.size.height, (self.size.height - tgtRec.origin.y)))
        UIGraphicsBeginImageContext(tgtSiz)
        self.drawInRect(CGRect(x: -tgtRec.origin.x, y: -tgtRec.origin.y, width: self.size.width, height: self.size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    func imageScalingToSize(tgtSiz: CGSize) -> UIImage {
        if (CGSizeEqualToSize(self.size, tgtSiz)) {
            return self
        }
        
        let sclVal = min(tgtSiz.width/self.size.width, tgtSiz.height/self.size.height)
        let objSiz = CGSize(width: self.size.width*sclVal, height: self.size.height*sclVal)
    
        UIGraphicsBeginImageContext(objSiz)
        self.drawInRect(CGRect(origin: CGPointZero, size: objSiz))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }

    func imageByDrawImage(imgDrw: UIImage, InRect imgRec:CGRect, whithCorRadius roundA: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        self.drawInRect(CGRect(origin: CGPointZero, size: self.size))
        if !roundA {
            imgDrw.drawInRect(imgRec)
        }
        else {
            let cnText = UIGraphicsGetCurrentContext()
            CGContextSaveGState(cnText)
            let corRad = min(imgRec.size.width, imgRec.size.height)*0.15
            CGContextMoveToPoint(cnText, imgRec.origin.x+imgRec.size.width-corRad, imgRec.origin.y)
            CGContextAddArc(cnText, imgRec.origin.x+imgRec.size.width-corRad, imgRec.origin.y+corRad, corRad, -CGFloat(M_PI_2), 0, 0)
            CGContextAddLineToPoint(cnText, imgRec.origin.x+imgRec.size.width, imgRec.origin.y+imgRec.size.height-corRad)
            CGContextAddArc(cnText, imgRec.origin.x+imgRec.size.width-corRad, imgRec.origin.y+imgRec.size.height-corRad, corRad, 0, CGFloat(M_PI_2), 0)
            CGContextAddLineToPoint(cnText, imgRec.origin.x+corRad, imgRec.origin.y+imgRec.size.height)
            CGContextAddArc(cnText, imgRec.origin.x+corRad, imgRec.origin.y+imgRec.size.height-corRad, corRad, CGFloat(M_PI_2), CGFloat(M_PI), 0)
            CGContextAddLineToPoint(cnText, imgRec.origin.x, imgRec.origin.y+corRad)
            CGContextAddArc(cnText, imgRec.origin.x+corRad, imgRec.origin.y+corRad, corRad, CGFloat(M_PI), -CGFloat(M_PI_2), 0)
            CGContextClosePath(cnText)
            CGContextClip(cnText)
            imgDrw.drawInRect(imgRec)
            CGContextRestoreGState(cnText)
        }
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    func squareImage() -> UIImage {
        let squrSz = max(self.size.width, self.size.height)
        let objSiz = CGSize(width: squrSz, height: squrSz)
        
        UIGraphicsBeginImageContext(objSiz)
        if let bkgClr = self.colorAtPixel(CGPoint(x: 1.0, y: 1.0)) {
            let cnText = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(cnText, bkgClr.CGColor)
            CGContextFillRect(cnText, CGRect(origin: CGPointZero, size: objSiz))
        }
        self.drawInRect(CGRect(origin: CGPoint(x: (squrSz-self.size.width)*0.5, y: (squrSz-self.size.height)*0.5), size: self.size))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
    
    func imageByReplaceColor(oColor: UIColor, with fColor:UIColor, Tolerance tlnVal: CGFloat) -> UIImage {
        //let imgRef = self.CGImage
        let iWidth = CGImageGetWidth(self.CGImage), iHight = CGImageGetHeight(self.CGImage)
        let clrSpc = CGColorSpaceCreateDeviceRGB()
        let bytPPx = 4, bytPRw = bytPPx*iWidth, btsPCm = 8, btsMBs = bytPRw*iHight
        let rwData = UnsafeMutablePointer<UInt8>(calloc(btsMBs, Int(BYTE_SIZE)))
        let cntext = CGBitmapContextCreate(rwData, iWidth, iHight, btsPCm, bytPRw, clrSpc, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        
        CGContextDrawImage(cntext, CGRect(origin: CGPointZero, size: CGSize(width: iWidth, height: iHight)), self.CGImage)
        
        var cCmpnt = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        oColor.getRed(&cCmpnt.0, green: &cCmpnt.1, blue: &cCmpnt.2, alpha: &cCmpnt.3)
        let redRng = (max(Int(cCmpnt.0*255.0 - tlnVal*127.5), 0), min(Int(cCmpnt.0*255.0 + tlnVal*127.5), 255))
        let grnRng = (max(Int(cCmpnt.1*255.0 - tlnVal*127.5), 0), min(Int(cCmpnt.1*255.0 + tlnVal*127.5), 255))
        let bluRng = (max(Int(cCmpnt.2*255.0 - tlnVal*127.5), 0), min(Int(cCmpnt.2*255.0 + tlnVal*127.5), 255))
        fColor.getRed(&cCmpnt.0, green: &cCmpnt.1, blue: &cCmpnt.2, alpha: &cCmpnt.3)
        
        var bytIdx = 0;
        while (bytIdx < btsMBs) {
            let cmpVal = (Int(rwData[bytIdx]), Int(rwData[bytIdx+1]), Int(rwData[bytIdx+2]))
            if cmpVal.0 >= redRng.0 && cmpVal.0 <= redRng.1 && cmpVal.1 >= grnRng.0 && cmpVal.1 <= grnRng.1 && cmpVal.2 >= bluRng.0 && cmpVal.2 <= bluRng.1 {
                    rwData[bytIdx] = UInt8(cCmpnt.0*255.0)
                    rwData[bytIdx + 1] = UInt8(cCmpnt.1*255.0)
                    rwData[bytIdx + 2] = UInt8(cCmpnt.2*255.0)
                    rwData[bytIdx + 3] = UInt8(cCmpnt.3*255.0)
            }
            
            bytIdx += 4;
        }
        
        guard let imgRef = CGBitmapContextCreateImage(cntext) else {
            free(rwData)
            return self
        }

        free(rwData)
        return UIImage(CGImage: imgRef)
    }
    
    func imageWithTintColor(tColor: UIColor, blendMode blMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tColor.setFill()
        let xwRect = CGRect(origin: CGPointZero, size: self.size)
        UIRectFill(xwRect)
    
    
        self.drawInRect(xwRect, blendMode: blMode, alpha: 1.0)
        if blMode != CGBlendMode.DestinationIn {
            self.drawInRect(xwRect, blendMode: CGBlendMode.DestinationIn, alpha: 1.0)
        }

        let tImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return tImage
    }

    func imageWithTintColor(tColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tColor, blendMode: CGBlendMode.DestinationIn)
    }
    
    func imageWithGradientTintColor(tColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tColor, blendMode: CGBlendMode.Overlay)
    }
    
    func imageWithLightEffect() -> UIImage? {
        return self.blurImage(WithRadius: 30, TintColor: UIColor(white: 1.0, alpha: 0.3), SaturationDeltaFactor: 1.8)
    }
    
    func imageWithExtraLightEffect() -> UIImage? {
        return self.blurImage(WithRadius: 20, TintColor: UIColor(white: 0.97, alpha: 0.82), SaturationDeltaFactor: 1.8)
    }
    
    func imageWithDarkEffect() -> UIImage? {
        return self.blurImage(WithRadius: 20, TintColor: UIColor(white: 0.11, alpha: 0.73), SaturationDeltaFactor: 1.8)
    }
    
    func imageWithTintEffectWithColor(tColor: UIColor) -> UIImage? {
        let eAlpha: CGFloat = 0.6
        var eColor = tColor
        let cCount = CGColorGetNumberOfComponents(tColor.CGColor);
        if 2 == cCount {
            var cWhite: CGFloat = 0.0
            if tColor.getWhite(&cWhite, alpha: nil) {
                eColor = UIColor(white: cWhite, alpha: eAlpha)
            }
        }
        else {
            var clrVal: (CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0)
            if tColor.getRed(&clrVal.0, green: &clrVal.1, blue: &clrVal.2, alpha: nil) {
                eColor = UIColor(red: clrVal.0, green: clrVal.1, blue: clrVal.2, alpha: eAlpha)
            }
        }
        return self.blurImage(WithRadius: 10, TintColor: eColor, SaturationDeltaFactor: -1.0)
    }
    
    
    func colorAtPixel(selPnt: CGPoint) -> UIColor? {
        guard CGRectContainsPoint(CGRect(origin: CGPointZero, size: self.size), selPnt) else {
            return nil
        }
    
        let pointX = trunc(selPnt.x), pointY = trunc(selPnt.y), iWidth = self.size.width, iHight = self.size.height, cgImag = self.CGImage, clrSpc = CGColorSpaceCreateDeviceRGB()
        let byt4Px = 4, byt4Rw = byt4Px*1, bitsPC = 8

        let pxData = UnsafeMutablePointer<UInt8>(calloc(4, Int(BYTE_SIZE)))
        let cnText = CGBitmapContextCreate(pxData, 1, 1, bitsPC, byt4Rw, clrSpc, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        //CGColorSpaceRelease(clrSpc)
        
        CGContextSetBlendMode(cnText, CGBlendMode.Copy)
        // Draw the pixel we are interested in onto the bitmap context
        CGContextTranslateCTM(cnText, -pointX, pointY-iHight)
        CGContextDrawImage(cnText, CGRect(x: 0.0, y: 0.0, width: iWidth, height: iHight), cgImag)
        //CGContextRelease(cnText)
        
        return UIColor(red:CGFloat(pxData[0])/255.0, green:CGFloat(pxData[1])/255.0, blue:CGFloat(pxData[2])/255.0, alpha:CGFloat(pxData[3])/255.0)
    }
    
}