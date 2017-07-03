//
//  Extensions.swift
//  colormeapp
//
//  Created by Max Nelson on 5/21/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit

//uicolor extension to add projsync colors
extension UIColor {
    
    open class var PSWhite: UIColor { return UIColor.init(red: 100/255, green: 104/255, blue: 114/255, alpha: 1) }
    open class var PSYellow: UIColor { return UIColor.init(red: 220/255, green: 175/255, blue: 64/255, alpha: 1) }
    open class var PSTan: UIColor { return UIColor.init(red: 159/255, green: 154/255, blue: 134/255, alpha: 1) }
    open class var PSGrayBlue: UIColor { return UIColor.init(red: 55/255, green: 66/255, blue: 75/255, alpha: 1) }
    open class var PSOriginalBlue: UIColor { return UIColor.init(red: 19/255, green: 42/255, blue: 75/255, alpha: 1) }
    open class var MNLightBlue: UIColor { return UIColor.init(red: 79/255, green: 172/255, blue: 254/255, alpha: 1) }
    open class var MNLighterBlue: UIColor { return UIColor.init(red: 99/255, green: 192/255, blue: 255/255, alpha: 1) }
    open class var MNBlack: UIColor { return UIColor.init(red: 35/255, green: 35/255, blue: 35/255, alpha: 1) }
    open class var MNGray: UIColor { return UIColor.init(red: 50/255, green: 54/255, blue: 64/255, alpha: 1) }

}

//uifont extension to add projsync fonts
extension UIFont {
    open class var PSFontFifteen: UIFont { return UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy) }
    open class var PSFontTwenty: UIFont { return UIFont.systemFont(ofSize: 20, weight: UIFontWeightHeavy) }
    open class var MNExoFontFifteen: UIFont { return UIFont(name: "Exo 2", size: 15)! }
    open class var MNExoFontTwenty: UIFont { return UIFont(name: "Exo 2", size: 20)! }
    open class var MNExoFontFifteenSemiBold: UIFont { return UIFont(name: "Exo2-SemiBold", size: 15)! }
    open class var MNExoFontTwentySemiBold: UIFont { return UIFont(name: "Exo2-SemiBold", size: 20)! }
    open class var MNExoFontFiftySemiBold: UIFont { return UIFont(name: "Exo2-SemiBold", size: 50)! }
    open class var MNExoFontFifteenReg: UIFont { return UIFont(name: "Exo2-Regular", size: 15)! }
    open class var MNExoFontTenReg: UIFont { return UIFont(name: "Exo2-Regular", size: 12)! }
    open class var MNExoFontTwentyReg: UIFont { return UIFont(name: "Exo2-Regular", size: 20)! }
}


//option sets to provide cases for different styles/types of projsync components
struct PSButtonAnimationType: OptionSet {
    //bitmask value
    let rawValue:Int
    
    //single direction
    static let slideRight = PSButtonAnimationType(rawValue: 1)
    static let slideLeft = PSButtonAnimationType(rawValue: 2)
    static let slideUp = PSButtonAnimationType(rawValue: 4)
    static let slideDown = PSButtonAnimationType(rawValue: 8)
    static let expand = PSButtonAnimationType(rawValue: 32)
    static let contract = PSButtonAnimationType(rawValue: 512)
    
    //mixing it up. diagonals.
    static let slideUpRight = [PSButtonAnimationType.slideRight, PSButtonAnimationType.slideUp]
    static let slideDownRight = [PSButtonAnimationType.slideRight, PSButtonAnimationType.slideDown]
    static let slideUpLeft = [PSButtonAnimationType.slideLeft, PSButtonAnimationType.slideUp]
    static let slideDownLeft = [PSButtonAnimationType.slideLeft, PSButtonAnimationType.slideDown]
    static let rotate = [PSButtonAnimationType.expand, PSButtonAnimationType.contract]
    
}

struct PSModalType: OptionSet {
    //bitmask value
    let rawValue:Int
    
    //single direction
    static let info = PSModalType(rawValue: 1)
    static let warning = PSModalType(rawValue: 2)
    static let error = PSModalType(rawValue: 4)
    
}

struct PSLabelType: OptionSet {
    //bitmask value
    let rawValue:Int
    
    //single direction
    static let original = PSLabelType(rawValue: 1)
    static let blueTitle = PSLabelType(rawValue: 2)
    static let noRect = PSLabelType(rawValue: 4)
    static let standardLabel = PSLabelType(rawValue: 8)
    static let noBorder = PSLabelType(rawValue: 16)
    static let none = PSLabelType(rawValue: 32)
    static let grayBlue = PSLabelType(rawValue: 64)
    static let standard = PSLabelType(rawValue: 128)
}


struct PSTextFieldType: OptionSet {
    //bitmask value
    let rawValue:Int
    
    //single direction
    static let original = PSTextFieldType(rawValue: 1)
    static let withoutLabel = PSTextFieldType(rawValue: 2)
}


struct PSImageType: OptionSet {
    //bitmask value
    let rawValue:Int
    
    //single direction
    static let gadzoomAndGLogo = PSImageType(rawValue: 1)
    static let plainGLogo = PSImageType(rawValue: 2)
    static let backgroundImage = PSImageType(rawValue: 128)
    static let blur = PSImageType(rawValue: 256)
    
    static let navy = PSImageType(rawValue: 4)
    static let yellow = PSImageType(rawValue: 8)
    static let tan = PSImageType(rawValue: 16)
    static let blue = PSImageType(rawValue: 32)
    static let solidnavy = PSImageType(rawValue: 64)
}

struct PSNavbarType: OptionSet {
    //bitmask value
    let rawValue:Int
    
    //single direction
    static let backWithBars = PSNavbarType(rawValue: 1)
    static let title = PSNavbarType(rawValue: 2)
}






//
//  Extensions.swift
//  Filterpedia
//
//  Created by Simon Gladman on 05/04/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit


extension UIBezierPath
{
    func interpolatePointsWithHermite(_ interpolationPoints : [CGPoint])
    {
        let n = interpolationPoints.count - 1
        
        for ii in 0 ..< n
        {
            var currentPoint = interpolationPoints[ii]
            
            if ii == 0
            {
                self.move(to: interpolationPoints[0])
            }
            
            var nextii = (ii + 1) % interpolationPoints.count
            var previi = (ii - 1 < 0 ? interpolationPoints.count - 1 : ii-1);
            var previousPoint = interpolationPoints[previi]
            var nextPoint = interpolationPoints[nextii]
            let endPoint = nextPoint;
            var mx : CGFloat = 0.0
            var my : CGFloat = 0.0
            
            if ii > 0
            {
                mx = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint.x) * 0.5;
                my = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint.y) * 0.5;
            }
            else
            {
                mx = (nextPoint.x - currentPoint.x) * 0.5;
                my = (nextPoint.y - currentPoint.y) * 0.5;
            }
            
            let controlPoint1 = CGPoint(x: currentPoint.x + mx / 3.0, y: currentPoint.y + my / 3.0)
            
            currentPoint = interpolationPoints[nextii]
            nextii = (nextii + 1) % interpolationPoints.count
            previi = ii;
            previousPoint = interpolationPoints[previi]
            nextPoint = interpolationPoints[nextii]
            
            if ii < n - 1
            {
                mx = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint.x) * 0.5;
                my = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint.y) * 0.5;
            }
            else
            {
                mx = (currentPoint.x - previousPoint.x) * 0.5;
                my = (currentPoint.y - previousPoint.y) * 0.5;
            }
            
            let controlPoint2 = CGPoint(x: currentPoint.x - mx / 3.0, y: currentPoint.y - my / 3.0)
            
            self.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
    }
}


extension CGFloat
{
    func toFloat() -> Float
    {
        return Float(self)
    }
}

extension CIVector
{
    func toArray() -> [CGFloat]
    {
        var returnArray = [CGFloat]()
        
        for i in 0 ..< self.count
        {
            returnArray.append(self.value(at: i))
        }
        
        return returnArray
    }
    
    func normalize() -> CIVector
    {
        var sum: CGFloat = 0
        
        for i in 0 ..< self.count
        {
            sum += self.value(at: i)
        }
        
        if sum == 0
        {
            return self
        }
        
        var normalizedValues = [CGFloat]()
        
        for i in 0 ..< self.count
        {
            normalizedValues.append(self.value(at: i) / sum)
        }
        
        return CIVector(values: normalizedValues,
                        count: normalizedValues.count)
    }
    
    func multiply(_ value: CGFloat) -> CIVector
    {
        let n = self.count
        var targetArray = [CGFloat]()
        
        for i in 0 ..< n
        {
            targetArray.append(self.value(at: i) * value)
        }
        
        return CIVector(values: targetArray, count: n)
    }
    
    func interpolateTo(_ target: CIVector, value: CGFloat) -> CIVector
    {
        return CIVector(
            x: self.x + ((target.x - self.x) * value),
            y: self.y + ((target.y - self.y) * value))
    }
}


extension UIColor
{
    func hue()-> CGFloat
    {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return hue
    }
}


