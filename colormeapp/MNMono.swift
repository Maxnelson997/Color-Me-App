//
//  MNMono.swift
//  colormeapp
//
//  Created by Max Nelson on 7/6/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import CoreImage

class MNMonoFilter: CIFilter
{
    var inputImage: CIImage?
    var inputRadius: CGFloat = 4
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "MNMono" as AnyObject,
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputRadius": [kCIAttributeIdentity: 0,
                            kCIAttributeClass: "NSNumber",
                            kCIAttributeDefault: 15,
                            kCIAttributeDisplayName: "Radius",
                            kCIAttributeMin: 0,
                            kCIAttributeSliderMin: 0,
                            kCIAttributeSliderMax: 30,
                            kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override func setDefaults()
    {
        inputRadius = 4
    }
    
    let fadeKernel = CIColorKernel(string:
        "kernel vec4 fadeToBW(__sample s, float factor)" +
            "{" +
            "vec3 lum = vec3(0.299,0.587,0.114);" +
            "vec3 bw = vec3(dot(s.rgb,lum));" +
            "vec3 pixel = s.rgb + (bw - s.rgb) * factor;" +
            "return vec4(pixel,s.a);" +
        "}"

    
//        "kernel vec4 fadeToBW(__sample s, float factor)" +
//            "{" +
//            "vec3 lum = vec3(0.5,0.17,0.94);" +
//            "vec3 bw = vec3(dot(s.rgb,lum));" +
//            "vec3 pixel = s.rgb + (bw - s.rgb) * factor;" +
//            "return vec4(pixel,s.a);" +
//        "}"
    )
    
    override var outputImage : CIImage!
    {
        if let inmage = inputImage,
            let fadeKernel = fadeKernel
        {
            let arguments = [inputImage!, inputRadius] as [Any]
            let extent = inmage.extent
            
            return fadeKernel.apply(withExtent: extent,
                                         roiCallback:
                {
                    (index, rect) in
                    return rect
            },
                                         arguments: arguments)!
        }
        return nil
    }
}

//
//class MNMono {
//    
//    var image:UIImage!
//    
//    init(image:CIImage, inputColorFade:NSNumber) {
//        self.image = UIImage(ciImage: createMonoImage(image: image, inputColorFade: inputColorFade))
//    }
//    
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
//    
//    func createMonoImage(image:CIImage, inputColorFade:NSNumber) -> CIImage {
//
//        
//        let inmage = image
//        let kuwaharaKernel = ciKernel
//        
//
//        
//    }
//}
