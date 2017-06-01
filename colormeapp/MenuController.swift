//
//  ViewController.swift
//  colormeapp
//
//  Created by Max Nelson on 5/21/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit
import Photos

class MenuController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var singleton = ColorMeSingleton.sharedInstance
    var appDelegate:AppDelegate!
    
    var open:Bool = false
    var background:UIImageView!
    var blurView:UIVisualEffectView!
    
    var imagePicked:UIImage!
    
    var logoLabel:PSLabel!
    var logoLabelConstraints:[NSLayoutConstraint]!
    
    var recentCV:UICollectionView = {
        let recentLayout = UICollectionViewFlowLayout()
        recentLayout.scrollDirection = .vertical
        recentLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        recentLayout.minimumLineSpacing = 5
        recentLayout.minimumInteritemSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: recentLayout)
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = 10
        cv.layer.borderWidth = 2
        cv.backgroundColor = UIColor.MNLighterBlue.withAlphaComponent(0.5)
        cv.layer.borderColor = UIColor.MNGray.cgColor
        cv.register(recentCell.self, forCellWithReuseIdentifier: "recent")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    var recentCVConstraints:[NSLayoutConstraint]!
    
    var buttonLayoutGuide:UILayoutGuide!
    var buttonLayoutGuideConstraints:[NSLayoutConstraint]!
    
    var cameraButton:PSButton!
    var cameraButtonConstraints:[NSLayoutConstraint]!
    
    var photosButton:PSButton!
    var photosButtonConstraints:[NSLayoutConstraint]!
    
    var recentButton:PSButton!
    var recentButtonConstraints:[NSLayoutConstraint]!
    
    override func viewDidAppear(_ animated: Bool) {
        singleton.filters = [CIFilter(name: "CIColorControls")!, CIFilter(name: "CIHighlightShadowAdjust")!, CIFilter(name: "CIExposureAdjust")!, CIFilter(name: "CIHueAdjust")!]
        singleton.imageNotPicked = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        grabPhotos()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        view.backgroundColor = UIColor.MNGray
        setupUIandConstraints()
        
        recentButton.addTarget(self, action: #selector(self.animate), for: .touchUpInside)
        photosButton.addTarget(self, action: #selector(self.photoPressed), for: .touchUpInside)
        cameraButton.addTarget(appDelegate.navigationController, action: #selector(appDelegate.navigationController.popViewController(animated:)), for: .touchUpInside)
    }
    
    func animate() {
        let (scale, blur, cvscale, cvalpha, text) = {
            open ? (scale: CGAffineTransform(scaleX: 1.1, y: 1.1), blur: 0, cvscale: CGAffineTransform(scaleX: 0.2, y: 0.1), cvalpha: 0, text: "COLOR ME") : (scale: CGAffineTransform(scaleX: 1.25, y: 1.25), blur: 0.8, cvscale: CGAffineTransform(scaleX: 1, y: 1), cvalpha: 1, text: "RECENT")
        }()
        
        self.view.layoutIfNeeded()
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                
                self.logoLabel.text = text
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {

            })
        }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 15, initialSpringVelocity: 20, options: .curveEaseIn, animations: {
            self.background.transform = scale
            self.logoLabel.transform = scale
            
            self.blurView.alpha = CGFloat(blur)
            self.recentCV.alpha = CGFloat(cvalpha)
        }, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, options: .curveEaseIn, animations: {
            self.recentCV.transform = cvscale
        }, completion: nil)
        
        open = !open
    }
    
    func setupUIandConstraints() {
        background = UIImageView(frame: view.frame)
        background.image = #imageLiteral(resourceName: "IMG_4820")
        background.contentMode = .scaleAspectFill
        background.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        view.addSubview(background)
        
        blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.alpha = 0
        blurView.frame = view.frame
        background.addSubview(blurView)
        
        logoLabel = PSLabel(fontSize: 60, type: [.standard], text: "COLOR ME")
        logoLabel.backgroundColor = UIColor.MNGray.withAlphaComponent(0.4)
        logoLabelConstraints = [
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            logoLabel.heightAnchor.constraint(equalTo: logoLabel.widthAnchor, multiplier: 1/4),
            logoLabel.bottomAnchor.constraint(lessThanOrEqualTo: recentCV.topAnchor, constant: -20),
            logoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10),
            logoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
        ]
        buttonLayoutGuide = UILayoutGuide()
        let recentWidth = recentCV.widthAnchor.constraint(equalToConstant: 320)
        recentWidth.priority = 749
        recentCVConstraints = [
            recentCV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recentWidth,
            recentCV.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            recentCV.heightAnchor.constraint(equalTo: recentCV.widthAnchor, multiplier: 1),
            recentCV.bottomAnchor.constraint(lessThanOrEqualTo: buttonLayoutGuide.topAnchor, constant: -20),
            recentCV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 60),
            recentCV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
        ]
        recentCV.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        recentCV.dataSource = self
        recentCV.delegate = self
        
        buttonLayoutGuideConstraints = [
            buttonLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonLayoutGuide.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            buttonLayoutGuide.heightAnchor.constraint(equalTo: buttonLayoutGuide.widthAnchor, multiplier: 1/4),
            buttonLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonLayoutGuide.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 60),
            buttonLayoutGuide.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
        ]
        
        cameraButton = PSButton(animationtype: [.slideRight], image: #imageLiteral(resourceName: "camera-shutter"))
        cameraButtonConstraints = [
            cameraButton.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            cameraButton.heightAnchor.constraint(equalTo: cameraButton.widthAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: buttonLayoutGuide.leadingAnchor),
            cameraButton.topAnchor.constraint(equalTo: buttonLayoutGuide.topAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: buttonLayoutGuide.bottomAnchor),
        ]
        
        photosButton = PSButton(animationtype: [.slideDown], image: #imageLiteral(resourceName: "picture-with-frame"))
        photosButtonConstraints = [
            photosButton.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            photosButton.heightAnchor.constraint(equalTo: photosButton.widthAnchor),
            photosButton.centerXAnchor.constraint(equalTo: buttonLayoutGuide.centerXAnchor),
            photosButton.topAnchor.constraint(equalTo: buttonLayoutGuide.topAnchor),
            photosButton.bottomAnchor.constraint(equalTo: buttonLayoutGuide.bottomAnchor),
        ]
        
        recentButton = PSButton(animationtype: [.slideLeft], image: #imageLiteral(resourceName: "microssoft-logo"))
        recentButtonConstraints = [
            recentButton.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            recentButton.heightAnchor.constraint(equalTo: recentButton.widthAnchor),
            recentButton.trailingAnchor.constraint(equalTo: buttonLayoutGuide.trailingAnchor),
            recentButton.topAnchor.constraint(equalTo: buttonLayoutGuide.topAnchor),
            recentButton.bottomAnchor.constraint(equalTo: buttonLayoutGuide.bottomAnchor),
        ]
        
        view.addSubview(logoLabel)
        view.addSubview(recentCV)
        view.addLayoutGuide(buttonLayoutGuide)
        view.addSubview(cameraButton)
        view.addSubview(photosButton)
        view.addSubview(recentButton)
        
        NSLayoutConstraint.activate(logoLabelConstraints)
        NSLayoutConstraint.activate(recentCVConstraints)
        NSLayoutConstraint.activate(buttonLayoutGuideConstraints)
        NSLayoutConstraint.activate(cameraButtonConstraints)
        NSLayoutConstraint.activate(photosButtonConstraints)
        NSLayoutConstraint.activate(recentButtonConstraints)
        
        print(recentCV.frame)
        animate()
        animate()
    }
    
    var images:[UIImage] = [] // <-- Array to hold the fetched images
    var numImagesNeeded:Int = 12 // <-- The number of images to fetch
    
    func grabPhotos(){
        
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let onlyImagesOptions = PHFetchOptions()
        onlyImagesOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        //  onlyImagesOptions.predicate = NSPredicate(format: "mediaType = %i", PHAssetMediaType.image.rawValue)
        
        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: onlyImagesOptions)
        
        if fetchResult.count > 0{
            
            for i in 0..<numImagesNeeded{
                
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: view.frame.size, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                    if image != nil {
                        self.images.append(image!)
                    } else {
                        print("dat image is nil sir")
                    }
                    
                })
            }
        }
        else{
            print("you got no photos")
            
        }
        
    }
    
    func photoPressed() {
        
        //go to camera roll. Select a photo. Then go to EditPhoto
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    //save the selected or taken image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("finished picking")
        /*if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
         print("edited")
         imagePicked = img
         } else */if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("original")
            singleton.imagePicked = img
         } else {
            print("not an image")
            //appDelegate.singleton.imagePicked = nil
        }
        self.dismiss(animated: true, completion: {
            self.appDelegate.goToEditController()
        })
        
    }
    
    //cv delegate datasource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recent", for: indexPath) as! recentCell
        cell.awakeFromNib()
        cell.imageView.image = images[indexPath.item]
        cell.imageView.tag = indexPath.item
        cell.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectRecentImage(sender:))))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func selectRecentImage(sender:UITapGestureRecognizer) {
        let imView = sender.view as! UIImageView
        singleton.imagePicked = images[imView.tag]
        appDelegate.goToEditController()
    }
    
    
}

