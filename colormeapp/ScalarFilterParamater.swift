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
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.name = name
        self.key = key
        self.currentValue = currentValue
    }
}
