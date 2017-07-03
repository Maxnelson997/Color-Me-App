//
//  FilteredImageView.swift
//  colormeapp
//
//  Created by Max Nelson on 5/24/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import GLKit
import OpenGLES


protocol ParameterAdjustmentDelegate {
    func parameterValueDidChange(_ param: ScalarFilterParameter, location:Int)
    func ChainAdjustValues()
}


class FilteredImageView: GLKView, ParameterAdjustmentDelegate {

    
    var singleton = ColorMeSingleton.sharedInstance

    var ciContext: CIContext!

    func resetFilters() {
        singleton.filters = [CIFilter(name: "CIColorControls")!, CIFilter(name: "CIHighlightShadowAdjust")!, CIFilter(name: "CIExposureAdjust")!, CIFilter(name: "CIHueAdjust")!]
        self.filter = singleton.filters[0]
    }
    
    var filter: CIFilter! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var inputImage: UIImage! {
        didSet {
            setNeedsDisplay()
            //resetFilters()
        }
    }
    
    var delegate1:SetFilter!
    
    override init(frame: CGRect) {
        super.init(frame: frame, context: EAGLContext(api: .openGLES2))
        clipsToBounds = true
        ciContext = CIContext(eaglContext: context)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        clipsToBounds = true
        self.context = EAGLContext(api: .openGLES2)
        ciContext = CIContext(eaglContext: context)
    }
    
    var currentAppliedFilter:String!
    
    override func draw(_ rect: CGRect) {
        if ciContext != nil && inputImage != nil && filter != nil {
            var originalimage:CIImage = CIImage(image: singleton.imagePicked)!
            
            
            for filters in singleton.filters {
                filters.setValue(originalimage, forKey: kCIInputImageKey)
                originalimage = filters.outputImage!

            }
            
            
            if currentAppliedFilter != nil {
                if currentAppliedFilter != "reset" {
                    print("CURRENT APPLIED FILTER: \(currentAppliedFilter!)")
                    let ciContext = CIContext(options: nil)
                    let coreImage = originalimage//cropView.image!
                    let filterz = CIFilter(name: currentAppliedFilter)
                    filterz!.setDefaults()
                    filterz!.setValue(coreImage, forKey: kCIInputImageKey)
                    let filteredImageData = filterz!.value(forKey: kCIOutputImageKey) as! CIImage
                    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
                    originalimage = CIImage(image: UIImage(cgImage: filteredImageRef!))!
                }

            } else {
                print("reset or does not exist")
            }

            if filter.outputImage != nil {
                clearBackground()
                let inputBounds = originalimage.extent
                let drawableBounds = CGRect(x: 0, y: 0, width: self.drawableWidth, height: self.drawableHeight)
                let targetBounds = imageBoundsForContentMode(inputBounds, toRect: drawableBounds)
                ciContext.draw(originalimage, in: targetBounds, from: inputBounds)
                delegate1.ApplyToCropView(image: UIImage(ciImage: originalimage))
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    func clearBackground() {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        glClearColor(GLfloat(r), GLfloat(g), GLfloat(b), GLfloat(a))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }
    
    func aspectFit(_ fromRect: CGRect, toRect: CGRect) -> CGRect {
        let fromAspectRatio = fromRect.size.width / fromRect.size.height;
        let toAspectRatio = toRect.size.width / toRect.size.height;
        
        var fitRect = toRect
        
        if (fromAspectRatio > toAspectRatio) {
            fitRect.size.height = toRect.size.width / fromAspectRatio;
            fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
        } else {
            fitRect.size.width = toRect.size.height  * fromAspectRatio;
            fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
        }
        
        return fitRect.integral
    }
    
    func aspectFill(_ fromRect: CGRect, toRect: CGRect) -> CGRect {
        let fromAspectRatio = fromRect.size.width / fromRect.size.height;
        let toAspectRatio = toRect.size.width / toRect.size.height;
        
        var fitRect = toRect
        
        if (fromAspectRatio > toAspectRatio) {
            fitRect.size.width = toRect.size.height  * fromAspectRatio;
            fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
        } else {
            fitRect.size.height = toRect.size.width / fromAspectRatio;
            fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
        }
        
        return fitRect.integral
    }
    
    func imageBoundsForContentMode(_ fromRect: CGRect, toRect: CGRect) -> CGRect {
        switch contentMode {
        case .scaleAspectFill:
            return aspectFill(fromRect, toRect: toRect)
        case .scaleAspectFit:
            return aspectFit(fromRect, toRect: toRect)
        default:
            return fromRect
        }
    }
    
    func ChainAdjustValues() {

        
    }
    
    func parameterValueDidChange(_ parameter: ScalarFilterParameter, location:Int) {
        //self.inputImage = UIImage(ciImage: filter.outputImage!)

        let param = parameter
        print(param.key)
        
        filter.setValue(param.currentValue, forKey: param.key)
        setNeedsDisplay()
    }
}
