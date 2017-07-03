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
