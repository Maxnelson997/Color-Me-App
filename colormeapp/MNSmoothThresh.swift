//
//  MNSmoothThresh.swift
//  colormeapp
//
//  Created by Max Nelson on 7/6/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit


class MNSmoothThreshold: CIFilter
{
    var inputImage : CIImage?
    var inputEdgeO: CGFloat = 0.1
    var inputEdge1: CGFloat = 0.5
    
    var colorKernel = CIColorKernel(string:
        "kernel vec4 color(__sample pixel, float inputEdgeO, float inputEdge1)" +
            "{" +
            "    float luma = dot(pixel.rgb, vec3(0.2126, 0.7152, 0.0722));" +
            "    float threshold = smoothstep(inputEdgeO, inputEdge1, luma);" +
            "    return vec4(threshold, threshold, threshold, 1.0);" +
        "}"
        
        
        //        "kernel vec4 chromaKey( __sample s, __color c, float threshold ) { \n" +
        //            "  vec4 diff = s.rgba - c;\n" +
        //            "  float distance = length( diff );\n" +
        //            "  float alpha = compare( distance - threshold, 0.0, 1.0 );\n" +
        //            "  return vec4( s.rgb, alpha ); \n" +
        //        "}"
    )
    
    override func setDefaults()
    {
        inputEdgeO = 0.1
        inputEdge1 = 0.5
    }
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let colorKernel = colorKernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage,
                         inputEdgeO,
                         inputEdge1] as [Any]
        
        return colorKernel.apply(withExtent: extent,
                                 arguments: arguments)
    }
}


class ChromaKeyFilter : CIFilter {


    var inputImage: CIImage?
    var activeColor = CIColor(red: 2.0, green: 1.0, blue: 0.0)
    var threshold: Float = 0.7
    
    override func setDefaults()
    {
        activeColor = CIColor(red: 1.0, green: 5.0, blue: 1.0)
        threshold = 0.85
    }

    override var outputImage: CIImage? {
        guard let inputImage = inputImage,
            let colorKernel = colorKernel else
        {
            return nil
        }
            let extent = inputImage.extent
            let arguments = [inputImage, activeColor, threshold] as [Any]
            return colorKernel.apply(withExtent: extent, arguments: arguments)
   
    }
    
    var colorKernel = CIColorKernel(string:
        "kernel vec4 chromaKey( __sample s, __color c, float threshold ) { \n" +
            "  vec4 diff = s.rgba - c;\n" +
            "  float distance = length( diff );\n" +
            "  float alpha = compare( distance - threshold, 0.0, 1.0 );\n" +
            "  return vec4( s.rgb, alpha ); \n" +
        "}"
        
        
        //        "kernel vec4 chromaKey( __sample s, __color c, float threshold ) { \n" +
        //            "  vec4 diff = s.rgba - c;\n" +
        //            "  float distance = length( diff );\n" +
        //            "  float alpha = compare( distance - threshold, 0.0, 1.0 );\n" +
        //            "  return vec4( s.rgb, alpha ); \n" +
        //        "}"
    )

}

// MARK:- Filter parameter serialization
extension ChromaKeyFilter {
    func encodeFilterParameters() -> NSData {
        var dataDict = [String : AnyObject]()
        dataDict["activeColor"] = activeColor
        dataDict["threshold"]   = threshold as AnyObject
        return NSKeyedArchiver.archivedData(withRootObject: dataDict) as NSData
    }
    
    func importFilterParameters(data: NSData?) {
        if let data = data {
            if let dataDict = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String : AnyObject] {
                activeColor = (dataDict["color"] as? CIColor) ?? activeColor
                threshold   = (dataDict["threshold"] as? Float) ?? threshold
            }
        }
    }
}

//
//  MNMono.swift
//  colormeapp
//
//  Created by Max Nelson on 7/6/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

//import CoreImage
//
//class MNSmoothThreshold: CIFilter
//{
//    var inputImage: CIImage?
//    var inputRadius: CGFloat = 4
//    
//    override var attributes: [String : Any]
//    {
//        return [
//            kCIAttributeFilterDisplayName: "MNMono" as AnyObject,
//            
//            "inputImage": [kCIAttributeIdentity: 0,
//                           kCIAttributeClass: "CIImage",
//                           kCIAttributeDisplayName: "Image",
//                           kCIAttributeType: kCIAttributeTypeImage],
//            
//            "inputRadius": [kCIAttributeIdentity: 0,
//                            kCIAttributeClass: "NSNumber",
//                            kCIAttributeDefault: 15,
//                            kCIAttributeDisplayName: "Radius",
//                            kCIAttributeMin: 0,
//                            kCIAttributeSliderMin: 0,
//                            kCIAttributeSliderMax: 30,
//                            kCIAttributeType: kCIAttributeTypeScalar]
//        ]
//    }
//    
//    override func setDefaults()
//    {
//        inputRadius = 4
//    }
//    
//    let fadeKernel = CIColorKernel(string:
//        "kernel vec4 fadeToBW(__sample s, float factor)" +
//            "{" +
//            "vec3 lum = vec3(0.299,0.587,0.114);" +
//            "vec3 bw = vec3(dot(s.rgb,lum));" +
//            "vec3 pixel = s.rgb + (bw - s.rgb) * factor;" +
//            "return vec4(pixel,s.a);" +
//        "}"
//        
//        
//        //        "kernel vec4 fadeToBW(__sample s, float factor)" +
//        //            "{" +
//        //            "vec3 lum = vec3(0.5,0.17,0.94);" +
//        //            "vec3 bw = vec3(dot(s.rgb,lum));" +
//        //            "vec3 pixel = s.rgb + (bw - s.rgb) * factor;" +
//        //            "return vec4(pixel,s.a);" +
//        //        "}"
//    )
//    
//    override var outputImage : CIImage!
//    {
//        if let inmage = inputImage,
//            let fadeKernel = fadeKernel
//        {
//            let arguments = [inputImage!, inputRadius] as [Any]
//            let extent = inmage.extent
//            
//            return fadeKernel.apply(withExtent: extent,
//                                    roiCallback:
//                {
//                    (index, rect) in
//                    return rect
//            },
//                                    arguments: arguments)!
//        }
//        return nil
//    }
//}
