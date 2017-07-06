//
//  CustomFilterManager.swift
//  colormeapp
//
//  Created by Max Nelson on 6/17/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import CoreImage
import UIKit

let CategoryCustomFilters = "Custom Filters"

class CustomFilterManager: NSObject, CIFilterConstructor {
    static func registerFilters() {
        CIFilter.registerName("MNEdgeGlow", constructor: CustomFilterManager(), classAttributes: [kCIAttributeFilterCategories: [CategoryCustomFilters]])
        
        CIFilter.registerName(
            "MNKuwahara",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        
        CIFilter.registerName(
            "MNCausticRefraction",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNMono",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNSmoothThreshold",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        
    }
    func filter(withName name: String) -> CIFilter? {
        switch name {
        case "MNEdgeGlow":
            return EdgeGlowFilter()
        case "MNKuwahara":
            return KuwaharaFilter()
        case "MNCausticRefraction":
            return CausticRefraction()
        case "MNMono":
            return MNMonoFilter()
        case "MNSmoothThreshold":
            return MNSmoothThreshold()
        default:
            return nil
        }
    }
    
}
