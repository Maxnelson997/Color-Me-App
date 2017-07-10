//
//  MNColorMeCells.swift
//  colormeapp
//
//  Created by Max Nelson on 5/22/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit

class recentCell:UICollectionViewCell {
    var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.MNBlack.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    override func awakeFromNib() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        imageView.removeFromSuperview()
    }
}

class ControlCell:UICollectionViewCell {
    
    var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    var label:UILabel = {
        let l = UILabel()
        l.font = UIFont.MNExoFontFifteenReg
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    fileprivate var visualEffectView: UIVisualEffectView = {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        vev.layer.cornerRadius = 7
        vev.layer.masksToBounds = true
        vev.isUserInteractionEnabled = false
        vev.translatesAutoresizingMaskIntoConstraints = false
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return vev
    }()
    override func awakeFromNib() {
        
        contentView.addSubview(visualEffectView)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            visualEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            
            ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            ])
        
    }
    
    override func prepareForReuse() {
        imageView.removeFromSuperview()
    }
    
}

class AdjustControlCell:UICollectionViewCell {
    
    


    var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.tintColor = .white
        return imageView
    }()
    
    var label:UILabel = {
        let l = UILabel()
        l.font = UIFont.MNExoFontTenReg
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    var slider:UISlider = {
        let l = UISlider()
        l.thumbTintColor = UIColor.MNLighterBlue
        l.tintColor = UIColor.MNGray
        l.backgroundColor = .clear//UIColor.MNGray.withAlphaComponent(0.4)
        return l
    }()

    var scalarFilterParam:ScalarFilterParameter!
    var filterLocation:Int!
    
    var delegate:ParameterAdjustmentDelegate!
   
    func sliderValueDidChange(_ sender: AnyObject?) {
        if delegate != nil {
            //cellsFilter.setValue(slider.value, forKey: parameter.key)
            delegate!.parameterValueDidChange(ScalarFilterParameter(key: scalarFilterParam.key, value: slider.value), location: filterLocation)
        }
    }

    var exists:Bool = false

    override func awakeFromNib() {
        if !exists {
            contentView.addSubview(visualEffectView)
            NSLayoutConstraint.activate([
                visualEffectView.leftAnchor.constraint(equalTo: leftAnchor),
                visualEffectView.rightAnchor.constraint(equalTo: rightAnchor),
                visualEffectView.topAnchor.constraint(equalTo: topAnchor),
                visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
                ])
            self.clipsToBounds = true
            slider.frame = CGRect(x: contentView.frame.maxX, y: 0, width: contentView.frame.width*3, height: contentView.frame.height)
            imageView.frame = CGRect(x: 0, y: contentView.frame.height * 0.2, width: contentView.frame.width, height: contentView.frame.height * 0.4)
            imageView.transform = CGAffineTransform(scaleX: 0.4, y: 1)
            label.frame = CGRect(x: 0, y: contentView.frame.maxY - (contentView.frame.height * 0.5), width: contentView.frame.width, height: contentView.frame.height * 0.5)
            slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
            exists = true
        }
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(slider)
        slider.minimumValue = scalarFilterParam.minimumValue!
        slider.maximumValue = scalarFilterParam.maximumValue!
        slider.value = scalarFilterParam.currentValue
    }
    
    fileprivate var visualEffectView: UIVisualEffectView = {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        vev.layer.cornerRadius = 7
        vev.layer.masksToBounds = true
        vev.isUserInteractionEnabled = false
        vev.translatesAutoresizingMaskIntoConstraints = false
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return vev
    }()
    
    override func prepareForReuse() {
        imageView.removeFromSuperview()
        slider.removeFromSuperview()
    }
    
}
protocol SetFilter {
    func ApplyFilter(filter:UIImage!, name:String!)
    func ApplyToCropView(image:UIImage!)
    func GetImageForCrop(image:UIImage!, originalWithCrop:UIImage!)
    func ImageForSaving(image:UIImage!)
}
class FilterPackControlCell:UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.tintColor = .white
        return imageView
    }()
    
    var label:UILabel = {
        let l = UILabel()
        l.font = UIFont.MNExoFontFifteenReg
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    var delegate:SetFilter!
    
    var filtersCollection:ControlCollection = ControlCollection()

    var filterPack:[filterObj] = []
  
    var awoken:Bool = false
    
    override func awakeFromNib() {
//        filtersCollection.layout.minimumLineSpacing = 0
//        filtersCollection.layout.minimumInteritemSpacing = 0
        if !awoken
        {
            contentView.addSubview(visualEffectView)
            NSLayoutConstraint.activate([
                visualEffectView.leftAnchor.constraint(equalTo: leftAnchor),
                visualEffectView.rightAnchor.constraint(equalTo: rightAnchor),
                visualEffectView.topAnchor.constraint(equalTo: topAnchor),
                visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
                ])
            self.clipsToBounds = true

            filtersCollection.translatesAutoresizingMaskIntoConstraints = true
           
            filtersCollection.dataSource = self
            filtersCollection.delegate = self
            filtersCollection.register(FilterCell.self, forCellWithReuseIdentifier: "filtercell")
//            filtersCollection.backgroundColor = 
            contentView.addSubview(label)
            
            imageView.frame = CGRect(x: 0, y: contentView.frame.height * 0.2, width: contentView.frame.width, height: contentView.frame.height * 0.4)
            imageView.transform = CGAffineTransform(scaleX: 0.4, y: 1)
            
            label.frame = CGRect(x: 0, y: contentView.frame.maxY - (contentView.frame.height * 0.5), width: contentView.frame.width, height: contentView.frame.height * 0.5)
            awoken = true
        
        }//+ 15 * CGFloat(filterPack.count) <--- add on the width
         filtersCollection.frame = CGRect(x: contentView.frame.maxX, y: 0, width: contentView.frame.width * CGFloat(filterPack.count) + 15 * CGFloat(filterPack.count) , height: contentView.frame.height)
        contentView.addSubview(imageView)
        contentView.addSubview(filtersCollection)
        print(filtersCollection.frame.width)
        filtersCollection.reloadData()
        if previousCell != nil
        {
            previousCell.backgroundColor = .clear
        }
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
//            imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
//            imageView.bottomAnchor.constraint(equalTo: label.topAnchor),
//            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
//            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
//            
//            ])
        
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor),
//            label.bottomAnchor.constraint(equalTo: bottomAnchor),
//            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
//            ])
//        
    }
    
    fileprivate var visualEffectView: UIVisualEffectView = {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        vev.layer.cornerRadius = 7
        vev.layer.masksToBounds = true
        vev.isUserInteractionEnabled = false
        vev.translatesAutoresizingMaskIntoConstraints = false
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return vev
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: indexPath) as! FilterCell
        cell.awakeFromNib()
        cell.imageView.image = filterPack[indexPath.item].image
        cell.label.text = filterPack[indexPath.item].name
        cell.layer.cornerRadius = 7
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterPack.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    var previousCell:UICollectionViewCell!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.MNLightBlue.withAlphaComponent(0.4)
        
        if previousCell != nil && previousCell != cell {
            previousCell.backgroundColor = UIColor.clear
        }
        previousCell = cell
        delegate?.ApplyFilter(filter: filterPack[indexPath.item].image, name: filterPack[indexPath.item].filterName)
    }
    
    override func prepareForReuse() {
        imageView.removeFromSuperview()
        filtersCollection.removeFromSuperview()
    }
    
}


class FilterCell:UICollectionViewCell {
    
    var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()
    
    var label:UILabel = {
        let l = UILabel()
        l.font = UIFont.MNExoFontFifteenReg
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    override func awakeFromNib() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
            ])
        
    }
    
    override func prepareForReuse() {
        imageView.removeFromSuperview()
        
    }
    
}
