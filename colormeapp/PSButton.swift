//
//  PSButton.swift
//  projsyncframework
//
//  Created by Max Nelson on 5/12/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit



class PSButton: UIButton {
    

    //initializers
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPhaseTwo()
    }
    
    //no frame
    init(animationtype: [PSButtonAnimationType], text: String, buttonstyle: [PSLabelType]?) {
        super.init(frame: .zero)
        if let newstyle = buttonstyle {
            self.label = PSLabel(fontSize: 25, type: newstyle)
            self.buttonStyle = newstyle
        }
        self.animationtype = animationtype
        self.label.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        initPhaseTwo()
        initWithLabel()
    }
    
    init(animationtype: [PSButtonAnimationType], image:UIImage) {
        super.init(frame: .zero)
        self.animationtype = animationtype
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imView.image = image.withRenderingMode(.alwaysTemplate)
        self.imView.tintColor = UIColor.white
        initPhaseTwo()
        InitWithImage()
    }
    
    init(animationtype: [PSButtonAnimationType], image:UIImage, text:String) {
        super.init(frame: .zero)
        self.animationtype = animationtype
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imView.image = image.withRenderingMode(.alwaysTemplate)
        self.imView.tintColor = UIColor.white
        self.label.text = text
        initPhaseTwo()
        InitWithImageAndText()
    }
    

    //custom frame
    public override required init(frame: CGRect) {
        super.init(frame: frame)
        initPhaseTwo()
    }
    
    func initPhaseTwo() {
        //button styling
        backgroundColor = .clear
        layer.borderColor = UIColor.MNGray.cgColor
        clipsToBounds = true

    }
    
    func InitWithImage() {
        self.addTarget(self, action: #selector(self.animatehelp), for: .touchUpInside)
        addSubview(visualEffectView)
        addSubview(imView)
        
        //layout label
        NSLayoutConstraint.activate([
            imView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            imView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            imView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            ])
        NSLayoutConstraint.activate([
            visualEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        
        
        //determine type to set transform direction
        setTransform()
        
    }
    
    func InitWithImageAndText() {
        self.addTarget(self, action: #selector(self.animatehelp), for: .touchUpInside)
        addSubview(visualEffectView)
        addSubview(imView)
        addSubview(label)
        
        label.backgroundColor = .gray
        
        //layout label
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: imView.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
            ])
        
        //layout image
        NSLayoutConstraint.activate([
            imView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            imView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            imView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -15),
            
            ])
        NSLayoutConstraint.activate([
            visualEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        
        
        //determine type to set transform direction
        setTransform()
        
    }
    
    func initWithLabel() {
        
        self.addTarget(self, action: #selector(self.animatehelp), for: .touchUpInside)
        
        addSubview(label)
        
        //layout label
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])

        //determine type to set transform direction
        setTransform()
    }

    
    //this overriden delegate method is needed because when the button is created the constraints have not yet been applied, resulting in every typeTransform case to have a cfaffinetransform value of 0
    override func updateConstraints() {
        super.updateConstraints()
        self.layoutIfNeeded()
        setTransform()
    }

    func setTransform() {
        if animationtype.contains(PSButtonAnimationType.slideRight) {
            typeTransform = CGAffineTransform(translationX: imView.frame.width, y: 0)
        }
        if animationtype.contains(PSButtonAnimationType.slideLeft) {
            typeTransform = CGAffineTransform(translationX: -imView.frame.width, y: 0)
        }
        if animationtype.contains(PSButtonAnimationType.slideUp) {
            typeTransform = CGAffineTransform(translationX: 0, y: -imView.frame.height)
        }
        if animationtype.contains(PSButtonAnimationType.slideDown) {
            typeTransform = CGAffineTransform(translationX: 0, y: imView.frame.height)
        }
        if animationtype.contains(PSButtonAnimationType.expand) {
            typeTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        if animationtype.contains(PSButtonAnimationType.contract) {
            typeTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        if buttonStyle.contains(PSLabelType.noBorder) {
            layer.cornerRadius = 0
            layer.borderWidth = 0
        }
    
        if animationtype == PSButtonAnimationType.rotate {
            typeTransform = CGAffineTransform(rotationAngle: 100000)
            self.backgroundColor = UIColor.PSYellow
            label.backgroundColor = .clear
        }
    }
    
    
    //private member variables
    fileprivate var label: UILabel = {
        let label = PSLabel(fontSize: 25, type: [.original])
        return label
    }()
    
    fileprivate var imView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    
    fileprivate var visualEffectView: UIVisualEffectView = {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        vev.layer.cornerRadius = 15
        vev.layer.masksToBounds = true
        vev.isUserInteractionEnabled = false
        vev.translatesAutoresizingMaskIntoConstraints = false
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return vev
    }()
    
    fileprivate var animationtype:[PSButtonAnimationType] = {
        return [PSButtonAnimationType.expand]
    }()
    
    fileprivate var buttonStyle:[PSLabelType] = {
        return [PSLabelType.none]
    }()
    
    fileprivate var typeTransform:CGAffineTransform = {
        return CGAffineTransform(scaleX: 10, y: 10)
    }()
    
    var radius:CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var borderWidth:CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    //getters and setters
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    var textColor: UIColor? {
        get {
            return label.textColor
        }
        set {
            label.textColor = newValue
        }
    }
    
    
    var textAlignment: NSTextAlignment {
        get {
            return label.textAlignment
        }
        set {
            label.textAlignment = newValue
        }
    }
    //overridden methods
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        animate(pressed: true)
//    }
    func animatehelp() {
        animate(pressed: true)
    }
    
    //private member functions
    func animate(pressed: Bool) {
        let (opacity, transf) = {
            pressed
                ?
            (opacity: 0.5, transf: typeTransform)
                :
            (opacity: 1.0, transf: CGAffineTransform(translationX: 0, y: 0))
        }()
        
        UIView.animate(
        withDuration: 0.4,
        delay: 0,
        usingSpringWithDamping: 2,
        initialSpringVelocity: 10,
        options: .curveEaseInOut,
        animations: {
            self.label.transform = transf
            self.label.alpha = CGFloat(opacity)
            self.imView.transform = transf
            self.imView.alpha = CGFloat(opacity)
        }, completion: { finished in
            if pressed {
                self.animate(pressed: false)
            }
        })
    }
    
    
    
    
    //global member functions
    func applyStandardConstraints() {
        
    }
    
    
    
    
    
}
