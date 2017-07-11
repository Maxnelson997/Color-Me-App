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


class Tile: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        //        let fi = CIFilter(name: "CIGlideReflectedTile")
        //        fi?.setDefaults()
        //        fi?.setValue(inputImage, forKey: "inputImage")
        //        fi?.setValue(CIVector(cgPoint: CGPoint(x: 150, y:150)), forKey: "inputCenter")
        //        fi?.setValue(55, forKey: "inputAngle")
        //        fi?.setValue(75, forKey: "inputWidth")
        
        
        let glide = inputImage.cropping(to: inputImage.extent)
            .applyingFilter("CIGlideReflectedTile", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputCenterKey: CIVector(cgPoint: CGPoint(x: 250, y: 150)),
                kCIInputAngleKey: 90,
                kCIInputWidthKey: 400,
                ])
        
        let finalComposite = glide.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        inputImage as Any])
        return finalComposite
        
    }
}

class Combine: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        //        let fi = CIFilter(name: "CIGlideReflectedTile")
        //        fi?.setDefaults()
        //        fi?.setValue(inputImage, forKey: "inputImage")
        //        fi?.setValue(CIVector(cgPoint: CGPoint(x: 150, y:150)), forKey: "inputCenter")
        //        fi?.setValue(55, forKey: "inputAngle")
        //        fi?.setValue(75, forKey: "inputWidth")
        
        let secondImage = CIImage(image: #imageLiteral(resourceName: "DSC06802"))
        let glide = inputImage.cropping(to: inputImage.extent)
            .applyingFilter("CIColorDodgeBlendMode", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputBackgroundImageKey: secondImage,
                ])
        
        let finalComposite = glide.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        inputImage as Any])
        return finalComposite
        
    }
}

class Copy: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        //        let fi = CIFilter(name: "CIGlideReflectedTile")
        //        fi?.setDefaults()
        //        fi?.setValue(inputImage, forKey: "inputImage")
        //        fi?.setValue(CIVector(cgPoint: CGPoint(x: 150, y:150)), forKey: "inputCenter")
        //        fi?.setValue(55, forKey: "inputAngle")
        //        fi?.setValue(75, forKey: "inputWidth")
        let secondImage = CIImage(image: #imageLiteral(resourceName: "DSC06802"))
        let f = CIFilter(name: "CICopyMachineTransition")
        print(f?.inputKeys)
        f?.setValue(inputImage, forKey: "inputImage")
        f?.setValue(secondImage, forKey: "inputTargetImage")
        f?.setValue(0.1, forKey: "inputOpacity")
        f?.setValue(0.27, forKey: "inputTime")
        f?.setValue(CIVector(cgRect: CGRect(x: 0, y: 0, width: 500, height: 0)), forKey: "inputExtent")
        f?.setValue(500, forKey: "inputWidth")
        
        f?.setValue(20, forKey: "inputAngle")
        f?.setValue(CIColor(red: 167, green: 253, blue: 216, alpha: 1), forKey: "inputColor")
        
        
        //        let secondImage = CIImage(image: #imageLiteral(resourceName: "DSC06802"))
        //        let glide = inputImage.cropping(to: inputImage.extent)
        //            .applyingFilter(f, withInputParameters: [
        //                kCIInputImageKey: inputImage,
        //                kCIInputTargetImageKey: secondImage,
        //                kCIInputTimeKey: 0.47,
        //                kCIInputAngleKey: 94.5,
        //                kCIInputWidthKey: 500,
        //                kCIInputColorKey: C
        //
        //                ])
        //
        
        
        let finalComposite = f?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        inputImage as Any])
        return finalComposite
        
    }
}

class Blend: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        //        let fi = CIFilter(name: "CIGlideReflectedTile")
        //        fi?.setDefaults()
        //        fi?.setValue(inputImage, forKey: "inputImage")
        //        fi?.setValue(CIVector(cgPoint: CGPoint(x: 150, y:150)), forKey: "inputCenter")
        //        fi?.setValue(55, forKey: "inputAngle")
        //        fi?.setValue(75, forKey: "inputWidth")
        let secondImage = CIImage(image: #imageLiteral(resourceName: "DSC06802"))
        let f = CIFilter(name: "CIDarkenBlendMode")
        f?.setValue(inputImage, forKey: "inputImage")
        f?.setValue(secondImage, forKey: "inputBackgroundImage")
        
        
        //        let secondImage = CIImage(image: #imageLiteral(resourceName: "DSC06802"))
        //        let glide = inputImage.cropping(to: inputImage.extent)
        //            .applyingFilter(f, withInputParameters: [
        //                kCIInputImageKey: inputImage,
        //                kCIInputTargetImageKey: secondImage,
        //                kCIInputTimeKey: 0.47,
        //                kCIInputAngleKey: 94.5,
        //                kCIInputWidthKey: 500,
        //                kCIInputColorKey: C
        //
        //                ])
        //
        
        
        let finalComposite = f?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        inputImage as Any])
        return finalComposite
        
    }
}

class Point: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }


        let f = CIFilter(name: "CIPointillize")
        f?.setValue(inputImage, forKey: "inputImage")
        f?.setValue(1, forKey: "inputRadius")
        f?.setValue(CIVector(cgPoint: CGPoint(x: 54, y: 150)), forKey: "inputCenter")
        

        let finalComposite = f?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                        inputImage as Any])
        return finalComposite
        
    }
}

class EdgeWork: CIFilter
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
            .applyingFilter("CIEdgeWork", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputRadiusKey: 0.6
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



class Crystalize: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let gamma = CIFilter(name: "CIGammaAdjust")
        gamma?.setValue(inputImage, forKey: "inputImage")
        gamma?.setValue(1.5, forKey: "inputPower")
        
        print(gamma?.inputKeys ?? "input keys")
        
        let vibrance = CIFilter(name: "CIVibrance")
        vibrance?.setValue(gamma?.outputImage, forKey: "inputImage")
        vibrance?.setValue(1, forKey: "inputAmount")
        print(vibrance?.inputKeys ?? "input keys")
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls?.setValue(gamma?.outputImage, forKey: "inputImage")
        colorControls?.setValue(-0.25, forKey: "inputBrightness")
        colorControls?.setValue(2, forKey: "inputContrast")
        print(colorControls?.inputKeys ?? "input keys")
        
        let mono = CIFilter(name: "CIColorMonochrome")
        mono?.setValue(vibrance?.outputImage, forKey: "inputImage")
        mono?.setValue(0.55, forKey: "inputIntensity")
        mono?.setValue(CIColor(red: 163, green: 146, blue: 166), forKey: "inputColor")
        print(mono?.inputKeys ?? "input keys")
        
        let noise = CIFilter(name: "CINoiseReduction")
        noise?.setValue(mono?.outputImage, forKey: "inputImage")
        noise?.setValue(0, forKey: "inputNoiseLevel")
        noise?.setValue(1.2, forKey: "inputSharpness")
        print(noise?.inputKeys ?? "input keys")
        
        let crystal = CIFilter(name: "CICrystallize")
        crystal?.setValue(noise?.outputImage?.cropping(to: inputImage.extent), forKey: "inputImage")
        crystal?.setValue(CIVector(cgPoint: CGPoint(x: 300, y: 500)), forKey: "inputCenter")
        crystal?.setValue(50, forKey: "inputRadius")
        print(crystal?.inputKeys ?? "input keys")
        
        let finalComposite = crystal?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    inputImage])
        
        
        return finalComposite
        
    }
}




class Expo: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        let gamma = CIFilter(name: "CIGammaAdjust")
        gamma?.setValue(inputImage, forKey: "inputImage")
        gamma?.setValue(1.5, forKey: "inputPower")
        
        print(gamma?.inputKeys ?? "input keys")
        
        let vibrance = CIFilter(name: "CIVibrance")
        vibrance?.setValue(gamma?.outputImage, forKey: "inputImage")
        vibrance?.setValue(1, forKey: "inputAmount")
        print(vibrance?.inputKeys ?? "input keys")
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls?.setValue(gamma?.outputImage, forKey: "inputImage")
        colorControls?.setValue(-0.25, forKey: "inputBrightness")
        colorControls?.setValue(2, forKey: "inputContrast")
        print(colorControls?.inputKeys ?? "input keys")
        
        let mono = CIFilter(name: "CIColorMonochrome")
        mono?.setValue(vibrance?.outputImage, forKey: "inputImage")
        mono?.setValue(0.55, forKey: "inputIntensity")
        mono?.setValue(CIColor(red: 163, green: 146, blue: 166), forKey: "inputColor")
        print(mono?.inputKeys ?? "input keys")
        
        let noise = CIFilter(name: "CINoiseReduction")
        noise?.setValue(mono?.outputImage, forKey: "inputImage")
        noise?.setValue(0, forKey: "inputNoiseLevel")
        noise?.setValue(1.2, forKey: "inputSharpness")
        print(noise?.inputKeys ?? "input keys")
        
        
        
        let finalComposite = noise?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    inputImage])
        
        return finalComposite
        
    }
}



class Blur: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let blur = CIFilter(name: "CIBoxBlur")
        blur?.setValue(inputImage, forKey: "inputImage")
        blur?.setValue(15, forKey: "inputRadius")
        print(blur?.inputKeys ?? "input keys")
        
        let finalComposite = blur?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    inputImage])
            .applyingFilter("CIColorControls", withInputParameters: [
//                kCIInputImageKey: inputImage,
//                kCIInputSaturationKey: 1,
                kCIInputBrightnessKey: -0.05,
//                kCIInputContrastKey: 1.5
                ])
        
        return finalComposite
    }
}


class BlurGamma: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let gamma = CIFilter(name: "CIGammaAdjust")
        gamma?.setValue(inputImage, forKey: "inputImage")
        gamma?.setValue(1.5, forKey: "inputPower")
        
        print(gamma?.inputKeys ?? "input keys")
        
        let blur = CIFilter(name: "CIBoxBlur")
        blur?.setValue(gamma?.outputImage, forKey: "inputImage")
        blur?.setValue(45, forKey: "inputRadius")
        print(blur?.inputKeys ?? "input keys")
        
        let noise = CIFilter(name: "CINoiseReduction")
        noise?.setValue(blur?.outputImage, forKey: "inputImage")
        noise?.setValue(0, forKey: "inputNoiseLevel")
        noise?.setValue(1.2, forKey: "inputSharpness")
        print(noise?.inputKeys ?? "input keys")
        
        
        
        let finalComposite = noise?.outputImage?.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    inputImage])
            .applyingFilter("CIColorControls", withInputParameters: [
                
                //                kCIInputSaturationKey: 1,
                kCIInputBrightnessKey: -0.05,
                //                kCIInputContrastKey: 1.5
                ])
        
        return finalComposite
        
    }
}


class litty: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let gamma = CIFilter(name: "CIGammaAdjust")
        gamma?.setValue(inputImage, forKey: "inputImage")
        gamma?.setValue(1.55, forKey: "inputPower")
        
        print(gamma?.inputKeys ?? "input keys")
        
        let colorImg = inputImage.cropping(to: inputImage.extent)
            .applyingFilter("CIColorControls", withInputParameters: [
                kCIInputImageKey: gamma?.outputImage!,
                kCIInputSaturationKey: 1.043,
                kCIInputBrightnessKey: 0.07403,
                kCIInputContrastKey: 1.136
                ])
    
        
        let finalComposite = inputImage.cropping(to: inputImage.extent)
            .applyingFilter(
                "CIAdditionCompositing",
                withInputParameters: [
                    kCIInputBackgroundImageKey:
                    colorImg])
        
        return finalComposite
        
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
                kCIInputBrightnessKey: 0.15,
                kCIInputContrastKey: 1.5
                ])
            .applyingFilter("CIGloom", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputRadiusKey: 45,
                kCIInputIntensityKey: 1
                ]).cropping(to: inputImage.extent)
        
        
        let finalComposite = inputImage
            .applyingFilter("CIAdditionCompositing", withInputParameters: [
                kCIInputBackgroundImageKey:withColorControls as Any
                ])
        
        return finalComposite
    }
}


class Comic: CIFilter
{
    var inputImage: CIImage?
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let withColorControls = CIFilter(name: "CIColorControls", withInputParameters: [
                kCIInputImageKey: inputImage,
                kCIInputSaturationKey: 1,
                kCIInputBrightnessKey: 1,
                kCIInputContrastKey: 1
                ])
            
            let withComic = withColorControls?.outputImage?
            .applyingFilter("CIComicEffect", withInputParameters: [
                kCIInputImageKey: inputImage
                ]).cropping(to: inputImage.extent)
        

        
        let finalComposite = withComic?
            .applyingFilter("CIAdditionCompositing", withInputParameters: [
                kCIInputBackgroundImageKey:withComic as Any
                ])
        
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
