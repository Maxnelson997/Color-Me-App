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
        CIFilter.registerName(
            "MNChroma",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNEightBit",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        
        CIFilter.registerName(
            "MNMars",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNVenus",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNLit",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNRed",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        
        CIFilter.registerName(
            "MNRedLoom",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        


        
        CIFilter.registerName(
            "MNBlueLoom",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])

        
        CIFilter.registerName(
            "MNBlueLoom1",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])

        CIFilter.registerName(
            "MNGreenLoom",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])

        CIFilter.registerName(
            "MNPurpleLoom",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNMaxBloom",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNComic",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNTile",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNCombine",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNCopy",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNBlend",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNEdgeWork",
            constructor: CustomFilterManager(),
            classAttributes: [
                kCIAttributeFilterCategories: [CategoryCustomFilters]
            ])
        CIFilter.registerName(
            "MNPoint",
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
        case "MNChroma":
            return ChromaKeyFilter()
        case "MNEightBit":
            return EightBit()
        case "MNMars":
            return MNMarsFilter()
        case "MNVenus":
            return MNVenusFilter()
        case "MNLit":
            return LitFilter()

        case "MNRed":
            return red()
        case "MNRedLoom":
            return RedLoom()
        case "MNBlueLoom":
            return BlueLoom()
        case "MNBlueLoom1":
            return BlueLoom1()
        case "MNGreenLoom":
            return GreenLoom()
        case "MNPurpleLoom":
            return PurpleLoom()
            
        case "MNMaxBloom":
            return MaxBloom()
        case "MNComic":
            return Comic()
            
        case "MNTile":
            return Tile()
        case "MNCombine":
            return Combine()
        case "MNCopy":
            return Copy()
        case "MNBlend":
            return Blend()
            
        case "MNEdgeWork":
            return EdgeWork()
            
        case "MNPoint":
            return Point()
default:
            return nil
        }
    }
    
}
