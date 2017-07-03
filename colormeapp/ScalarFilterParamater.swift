//
//  ScalarFilterParamater.swift
//  colormeapp
//
//  Created by Max Nelson on 5/24/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import Foundation


struct ScalarFilterParameter
{
    var name: String?
    var key: String
    var minimumValue: Float?
    var maximumValue: Float?
    var currentValue: Float
    
    init(key: String, value: Float) {
        self.key = key
        self.currentValue = value
    }
    
    init(name: String, key: String, minimumValue: Float, maximumValue: Float, currentValue: Float)
    {
        print("name: \(name)")
        print("key: \(key)")
        print("minimumValue: \(minimumValue)")
        print("maximumValue: \(maximumValue)")
        print("currentValue: \(currentValue)")
        
        switch name {
        case "inputBrightness":
            self.minimumValue = -0.01
            self.maximumValue = 0.2
            self.currentValue = 0
        case "inputContrast":
            self.minimumValue = 0.9
            self.maximumValue = 1.1
            self.currentValue = 1
        case "inputRadius":
            self.minimumValue = 0
            self.maximumValue = 10
            self.currentValue = 0
        case "inputHighlightAmount":
            self.minimumValue = 0
            self.maximumValue = 2
            self.currentValue = 1.0
        case "inputEV":
            self.minimumValue = -1
            self.maximumValue = 1
            self.currentValue = 0
        default:
            self.minimumValue = minimumValue
            self.maximumValue = maximumValue
            self.currentValue = currentValue
        }

        self.name = name
        self.key = key
        
    }
}
