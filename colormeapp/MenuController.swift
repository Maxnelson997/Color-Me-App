//
//  ViewController.swift
//  colormeapp
//
//  Created by Max Nelson on 5/21/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit
import Photos
import PopupDialog

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
        cv.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
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
    
    var setDelegate:Bool = false
    
    var pop:PopupDialog = PopupDialog(title: "Picture Taken", message: "Wait a second while we get your picture ready.")
    var pop1:PopupDialog = PopupDialog(title: "Getting Photos.", message: "It takes a second the first time.")
    
    override func viewDidAppear(_ animated: Bool) {
        singleton.filters = [CIFilter(name: "CIColorControls")!, CIFilter(name: "CIHighlightShadowAdjust")!, CIFilter(name: "CIExposureAdjust")!, CIFilter(name: "CIHueAdjust")!]
        singleton.imageNotPicked = true
        if singleton.didTakePic {
            self.singleton.didTakePic = false
            self.present(self.pop, animated: true, completion: {
                
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.pop.dismiss()
                self.appDelegate.goToEditController()
                
            })
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        inMenu = false
    }
    
    var inMenu:Bool = true
    
    func animateBg(img:UIImage) {
        UIView.animate(withDuration: 1, animations: {
            self.background.alpha = 0
            
        }, completion: { finished in
            self.background.image = img
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.background.alpha = 1
            }, completion: { finished in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.animateBg(img: self.bgArray[self.bgIndex])
                })
            })

            self.prevBGIndex = self.bgIndex
            self.bgIndex += 1
            if self.bgIndex == 4 {
                self.bgIndex = 0
            }
            
        })
 
    }
    
    var bgArray:[UIImage] = [#imageLiteral(resourceName: "8A403A02-9055-4F63-A7AA-23CDBC4883A0"), #imageLiteral(resourceName: "jer-1"),#imageLiteral(resourceName: "DSC04982-2"),#imageLiteral(resourceName: "pol")]
    var prevBGIndex:Int = -1
    
    var bgIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
//        view.backgroundColor = UIColor.MNGray
        view.backgroundColor = UIColor.white
        background = UIImageView(frame: view.frame)
        background.image = #imageLiteral(resourceName: "pol")//#imageLiteral(resourceName: "8A403A02-9055-4F63-A7AA-23CDBC4883A0")//#imageLiteral(resourceName: "jer-1")//#imageLiteral(resourceName: "pol")
        background.contentMode = .scaleAspectFill
        background.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.addSubview(background)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
            self.animateBg(img: self.bgArray[self.bgIndex])
        })


        
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        vev.layer.cornerRadius = 0
        vev.layer.masksToBounds = true
        vev.frame = view.frame
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.addSubview(vev)
        
        blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.alpha = 0
        blurView.frame = view.frame
        background.addSubview(blurView)
        snatchImages(completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.setupUIandConstraints()
                
                self.appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                self.background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animate)))
                self.background.isUserInteractionEnabled = true
                
                
                self.recentButton.addTarget(self, action: #selector(self.animate), for: .touchUpInside)
                self.photosButton.addTarget(self, action: #selector(self.photoPressed), for: .touchUpInside)
                self.cameraButton.addTarget(self.appDelegate.navigationController, action: #selector(self.appDelegate.navigationController.popViewController(animated:)), for: .touchUpInside)
          
                self.recentCV.alpha = 0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.recentCV.transform = CGAffineTransform(scaleX: 0.2, y: 0.1)

        
                })
            })
            
            

        })

        

        

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    func animate() {

        let (backscale, scale, blur, cvscale, cvalpha, text) = {
            open ? (backscale: CGAffineTransform(scaleX: 1, y: 1), scale: CGAffineTransform(translationX: 0, y: 0), blur: 0, cvscale: CGAffineTransform(scaleX: 0.2, y: 0.1), cvalpha: 0, text: "COLOR ME") : (backscale: CGAffineTransform(scaleX: 1.2, y: 1.2),scale: CGAffineTransform(translationX: 0, y: 20), blur: 0.8, cvscale: CGAffineTransform(scaleX: 1, y: 1), cvalpha: 1, text: "RECENT PICS")
        }()
        
        self.view.layoutIfNeeded()
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                
                self.logoLabel.text = text
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {

            })
        }, completion: nil)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
            self.background.transform = backscale
            self.logoLabel.transform = scale
            self.recentCV.transform = cvscale
            self.recentCV.alpha = CGFloat(cvalpha)
            self.blurView.alpha = CGFloat(blur)
  
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 20, options: .curveEaseIn, animations: {
            
        }, completion: nil)
        
        open = !open
    }
    
    func setupUIandConstraints() {

        
        logoLabel = PSLabel(fontSize: 60, type: [.standard], text: "COLOR ME")
        logoLabel.backgroundColor = UIColor.MNGray.withAlphaComponent(0.6)
        let wr = logoLabel.widthAnchor.constraint(equalToConstant: 375)
        wr.priority = 500
        logoLabelConstraints = [
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wr,
            logoLabel.heightAnchor.constraint(equalToConstant: 60),
            logoLabel.bottomAnchor.constraint(lessThanOrEqualTo: recentCV.topAnchor, constant: -20),
            logoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 35),
            logoLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -35),
        ]
        buttonLayoutGuide = UILayoutGuide()


        buttonLayoutGuideConstraints = [
            buttonLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonLayoutGuide.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            buttonLayoutGuide.heightAnchor.constraint(equalTo: buttonLayoutGuide.widthAnchor, multiplier: 1/4),
            buttonLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonLayoutGuide.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 60),
            buttonLayoutGuide.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
        ]
        
        cameraButton = PSButton(animationtype: [.slideDown], image: #imageLiteral(resourceName: "camera-shutter"))
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
        
        recentButton = PSButton(animationtype: [.slideDown], image: #imageLiteral(resourceName: "microssoft-logo"))
    
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
        let recentWidth = recentCV.widthAnchor.constraint(equalToConstant: 320)
        recentWidth.priority = 749
        recentCVConstraints = [
            recentCV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recentWidth,
            recentCV.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            recentCV.heightAnchor.constraint(equalTo: recentCV.widthAnchor, multiplier: 1.1),
            recentCV.bottomAnchor.constraint(lessThanOrEqualTo: buttonLayoutGuide.topAnchor, constant: -40),
            recentCV.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 60),
            recentCV.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
        ]

        NSLayoutConstraint.activate(recentCVConstraints)
        NSLayoutConstraint.activate(buttonLayoutGuideConstraints)
        NSLayoutConstraint.activate(cameraButtonConstraints)
        NSLayoutConstraint.activate(photosButtonConstraints)
        NSLayoutConstraint.activate(recentButtonConstraints)
        

   
    }
 
    var images:[UIImage] = [] // <-- Array to hold the fetched images
    var numImagesNeeded:Int = 12 // <-- The number of images to fetch
    func snatchImages(completion: @escaping () -> Void)  {
        
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
            self.setDelegate = true
            
            if setDelegate {

                recentCV.dataSource = self
                recentCV.delegate = self
                self.pop1.dismiss()
                completion()
            }
        }
        else{
            print("you got no photos")
            //check if they've allowed access
            let status = PHPhotoLibrary.authorizationStatus()
            if status == PHAuthorizationStatus.authorized {
                //no photos
            
            } else if status == PHAuthorizationStatus.notDetermined || status == PHAuthorizationStatus.denied {
                //havent declined nor accepted
                //user has previously denied access. ask them again.
                PHPhotoLibrary.requestAuthorization({ (newstat) in
                    if newstat == PHAuthorizationStatus.authorized {
                        //unk cool
                        //dont set the delete of the recent cv yet because we still need to snatch some images, if they are there after authorization to the photo library has been granted
                        self.setDelegate = false
                        
     

                        //grab photos once more
                        self.snatchImages(completion: {
                            completion()
                        })
                    }
                    else if newstat == PHAuthorizationStatus.denied {
                        //hmm weird why tho.
                    }
                    
                })
            }

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
        cell.imageView.contentMode = .scaleAspectFit
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

