//
//  ColorMeSingleton.swift
//  colormeapp
//
//  Created by Max Nelson on 5/22/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit



class ColorMeSingleton {
    static let sharedInstance = ColorMeSingleton()
    
    private init() {}
    
    var imageNotPicked:Bool = true
    
    var imagePicked:UIImage = #imageLiteral(resourceName: "pol") {
        didSet {
            applyfilters()
        }
    }
    var drawnImage:UIImage = UIImage()
    
    func applyfilters() {
        for filter in filters {
            filter.setValue(CIImage(image: imagePicked), forKey: kCIInputImageKey)
        }
    }

    var filters:[CIFilter] = [CIFilter(name: "CIColorControls")!, CIFilter(name: "CIHighlightShadowAdjust")!, CIFilter(name: "CIExposureAdjust")!, CIFilter(name: "CIHueAdjust")!]
    
    var filtersToSet:[String] = ["CIColorControls", "CIHighlightShadowAdjust", "CIExposureAdjust", "CIHueAdjust"]
}
