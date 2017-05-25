//
//  PSLabel.swift
//  projsyncframework
//
//  Created by Max Nelson on 5/12/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit

class PSLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(fontSize: CGFloat, type:[PSLabelType], text:String) {
        super.init(frame: .zero)
        self.fontSize = fontSize
        self.type = type
        self.labeltext = text
        initPhaseTwo()
    }
    
    init(fontSize: CGFloat, type:[PSLabelType]) {
        super.init(frame: .zero)
        self.fontSize = fontSize
        self.type = type
        initPhaseTwo()
    }
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        self.fontSize = fontSize
        initPhaseTwo()
    }

    init() {
        super.init(frame: .zero)
        self.fontSize = 15
        initPhaseTwo()
    }
    
    fileprivate func initPhaseTwo() {
        //determine label type
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 6
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor.white
        self.isUserInteractionEnabled = false
        self.text = labeltext
        
        if type.contains(.standard) {
            self.backgroundColor = UIColor.clear
            self.layer.borderColor = UIColor.clear.cgColor
            self.textColor = UIColor.white
            self.font = UIFont.MNExoFontFiftySemiBold
        }
        
        if type.contains(.original) {
            self.layer.borderColor = UIColor.PSGrayBlue.cgColor
            self.backgroundColor = UIColor.MNLightBlue
        }
        if type.contains(.blueTitle) {
            self.layer.borderColor = UIColor.PSGrayBlue.cgColor
            self.backgroundColor = UIColor.PSOriginalBlue
        }
        if type.contains(.noRect) {
            self.layer.borderColor = UIColor.PSGrayBlue.cgColor
            self.backgroundColor = UIColor.clear
            self.textAlignment = .left
            self.adjustsFontSizeToFitWidth = true
        }
        if type.contains(.standardLabel) {
            self.backgroundColor = UIColor.PSGrayBlue
            self.layer.borderColor = UIColor.PSGrayBlue.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 0
            self.layer.masksToBounds = true
            self.sizeToFit()
        }
        if type.contains(.grayBlue) {
            self.backgroundColor = .clear
        }
    }
    

    fileprivate var labeltext:String = "Press Me"
    
    var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.systemFont(
                ofSize: newValue,
                weight: UIFontWeightHeavy
            )
        }
    }
    
    fileprivate var type:[PSLabelType] = {
        return [PSLabelType.original]
    }()
    
    override func drawText(in rect: CGRect) {
        if type.contains(PSLabelType.noRect) {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)))
            return
        }
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
    }

    
    
}
