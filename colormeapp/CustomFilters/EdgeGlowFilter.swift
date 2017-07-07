//
//  EdgeGlowFilter.swift
//  colormeapp
//
//  Created by Max Nelson on 6/17/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit
import CoreImage

class EdgeGlowFilter: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let edgesImage = inputImage
            .applyingFilter(
                "CIEdges",
                withInputParameters: [
                    kCIInputIntensityKey: 10])
        let glowingImage = CIFilter(
            name: "CIColorControls",
            withInputParameters: [
                kCIInputImageKey: edgesImage,
                kCIInputSaturationKey: 1.75])?
            .outputImage?
            .applyingFilter(
                "CIBloom",
                withInputParameters: [
                    kCIInputRadiusKey: 2.5,
                    kCIInputIntensityKey: 1.25])
            .cropping(to: inputImage.extent)
        let darkImage = inputImage
            .applyingFilter(
                "CIPhotoEffectNoir",
                withInputParameters: nil)
            .applyingFilter(
                "CIExposureAdjust",
                withInputParameters: [
                    "inputEV": -1.5])
        let finalComposite = glowingImage!
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    darkImage])
        return finalComposite
    }
}


class LitFilter: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let glowingImage = CIFilter(
            name: "CIColorControls",
            withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1.55])?
            .outputImage?
            .cropping(to: inputImage.extent)
        let darkImage = inputImage
            .applyingFilter(
                "CIPhotoEffectNoir",
                withInputParameters: nil)
            .applyingFilter(
                "CIExposureAdjust",
                withInputParameters: [
                    "inputEV": -1.5])
        let finalComposite = glowingImage!
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    darkImage])
        return finalComposite
    }
}

class RedLoom: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
        colorMatrixFilter?.setDefaults()
        colorMatrixFilter?.setValue(inputImage, forKey: "inputImage")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0,z:0.5,w:0.5), forKey: "inputRVector")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0.5,z:0.5,w:0), forKey: "inputGVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputBVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputAVector")
        print(colorMatrixFilter?.inputKeys ?? "input keys")
        let withGloom = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputRadiusKey: 100,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        let finalComposite = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        withGloom as Any])
        return finalComposite
        //        if let ciimage = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent) {
        //            return ciimage
        //        }
        //        return nil
    }
}

class BlueLoom: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let withColorControls = inputImage
            .applyingFilter("CIColorControls", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1.7,
                kCIInputBrightnessKey: 0.08,
                kCIInputContrastKey: 1.15
                ])
        
        let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
        colorMatrixFilter?.setDefaults()
        colorMatrixFilter?.setValue(withColorControls, forKey: "inputImage")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0.5,z:0.5,w:0), forKey: "inputGVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputBVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputAVector")
        
        print(colorMatrixFilter?.inputKeys ?? "input keys")
        
        let withGloom = inputImage
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: colorMatrixFilter?.outputImage! as Any,
                kCIInputRadiusKey: 100,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        
        let finalComposite = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        withGloom as Any])
        return finalComposite
    }
}
class BlueLoom1: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let withColorControls = inputImage
            .applyingFilter("CIColorControls", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1.7,
                kCIInputBrightnessKey: 0.08,
                kCIInputContrastKey: 1.15
                ])
        
        let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
        colorMatrixFilter?.setDefaults()
        colorMatrixFilter?.setValue(withColorControls, forKey: "inputImage")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0,z:0.5,w:0.5), forKey: "inputGVector")
        colorMatrixFilter?.setValue(CIVector(x:0,y:1,z:0,w:1), forKey: "inputBVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputAVector")
        
        print(colorMatrixFilter?.inputKeys ?? "input keys")
        
        let withGloom = inputImage
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: colorMatrixFilter?.outputImage! as Any,
                kCIInputRadiusKey: 100,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        
        let finalComposite = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        withGloom as Any])
        return finalComposite
    }
}

class GreenLoom: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let withColorControls = inputImage
            .applyingFilter("CIColorControls", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1.7,
                kCIInputBrightnessKey: 0.08,
                kCIInputContrastKey: 1.15
                ])
        
        let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
        colorMatrixFilter?.setDefaults()
        colorMatrixFilter?.setValue(withColorControls, forKey: "inputImage")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0,z:0.5,w:0.5), forKey: "inputGVector")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0.2,z:0,w:0.2), forKey: "inputBVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputAVector")
        
        print(colorMatrixFilter?.inputKeys ?? "input keys")
        
        let withGloom = inputImage
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: colorMatrixFilter?.outputImage! as Any,
                kCIInputRadiusKey: 100,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        
        let finalComposite = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        withGloom as Any])
        return finalComposite
    }
}

class PurpleLoom: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let withColorControls = inputImage
            .applyingFilter("CIColorControls", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1.5,
                kCIInputBrightnessKey: 0.08,
                kCIInputContrastKey: 1.1
                ])
        
        let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
        colorMatrixFilter?.setDefaults()
        colorMatrixFilter?.setValue(withColorControls, forKey: "inputImage")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0.5,z:0.5,w:0), forKey: "inputRVector")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0,z:0,w:0.15), forKey: "inputGVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputBVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputAVector")
        
        print(colorMatrixFilter?.inputKeys ?? "input keys")
        
        let withGloom = inputImage
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: colorMatrixFilter?.outputImage! as Any,
                kCIInputRadiusKey: 100,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        
        let finalComposite = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        withGloom as Any])
        return finalComposite
    }
}


class MaxBloom: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let withColorControls = inputImage
            .applyingFilter("CIColorControls", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1.8,
                kCIInputBrightnessKey: 0.25,
                kCIInputContrastKey: 1.15
                ])
        

        
        let withGloom = inputImage
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: withColorControls,
                kCIInputRadiusKey: 45,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        
        let finalComposite = withGloom
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        withGloom as Any])
        return finalComposite
    }
}


class red: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
        colorMatrixFilter?.setDefaults()
        colorMatrixFilter?.setValue(inputImage, forKey: "inputImage")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0,z:0.5,w:0.5), forKey: "inputRVector")
        colorMatrixFilter?.setValue(CIVector(x:0,y:0.5,z:0.5,w:0), forKey: "inputGVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputBVector")
        colorMatrixFilter?.setValue(CIVector(x:1,y:1,z:0,w:0), forKey: "inputAVector")
        print(colorMatrixFilter?.inputKeys ?? "input keys")

        let finalComposite = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    inputImage])
        
        return finalComposite
        //        if let ciimage = colorMatrixFilter?.outputImage?.cropping(to: inputImage.extent) {
        //            return ciimage
        //        }
        //        return nil
    }
}
