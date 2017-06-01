//
//  EditController.swift
//  colormeapp
//
//  Created by Max Nelson on 5/21/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit
import AKImageCropperView

extension EditController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        print("New crop rectangle: \(rect)")
    }
    
    func cropImageAction() {
        cropView.image = cropView.croppedImage
        filteredImageView.inputImage = cropView.image
        cropView.hideOverlayView(animationDuration: 0.3)
        updateFilters()
    }
    
    func showHideOverlayAction() {
        if cropView.isOverlayViewActive {
            cropView.hideOverlayView(animationDuration: 0.3)
        } else {
            cropView.showOverlayView(animationDuration: 0.3)
        }
    }
     
    func rotateAction() {
        angle += .pi/2
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            if self.angle == 2 * .pi {
                self.angle = 0.0
            }
        })
        
    }
    
    
}

class EditController: UIViewController, SetFilter {
    var angle: Double = 0.0
    var applyyet:Bool = false
    
    func ApplyToCropView(image: UIImage!) {
        self.cropView.image = image
        print("edited image applied to cropview")
    }
    
    func ApplyFilter(filter: UIImage!) {
        appDelegate.singleton.imagePicked = filter
        filteredImageView.inputImage = filter
        
    }
    
    func backTappedToCloseCV() {
        tappedIndexPath = nil
        filterControlsCollection.performBatchUpdates({
            self.filterControlsCollection.collectionViewLayout.invalidateLayout()
            self.filterControlsCollection.reloadData()
        }, completion: { finished in
            self.appDelegate.navigationController.popViewController(animated: true)
        })
    }
    
    var appDelegate:AppDelegate!
    
    var imageView:UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.clipsToBounds = true
        i.backgroundColor = UIColor.MNGray
        i.translatesAutoresizingMaskIntoConstraints = false
       return i
    }()
    
    var imageViewConstraints:[NSLayoutConstraint]!
    var filteredImageView:FilteredImageView!
    var cropView:AKImageCropperView!
    var cropperImageViewConstraints:[NSLayoutConstraint]!
    var imView:UIImageView!
    
    var mainControlsLayoutGuide:UILayoutGuide = UILayoutGuide()
    var mainControlsLayoutGuideConstraints:[NSLayoutConstraint]!
    
    var controlsLayoutGuide:UILayoutGuide  = UILayoutGuide()
    var controlsLayoutGuideConstraints:[NSLayoutConstraint]!
    
    var mainControlsCollection:ControlCollection = ControlCollection()
    var mainControlsConstraints:[NSLayoutConstraint]!
    var mainControlsImages:[UIImage]!
    var mainControlsText:[String]!
    
    var cropControlsCollection:ControlCollection = ControlCollection()
    var cropControlsConstraints:[NSLayoutConstraint]!
    var cropControlsImages:[UIImage]!
    var cropControlsText:[String]!
    
    var paintControlsCollection:ControlCollection = ControlCollection()
    var paintControlsConstraints:[NSLayoutConstraint]!
    var paintControlsImages:[UIImage]!
    var paintControlsText:[String]!
    
    var adjustControlsCollection:ControlCollection = ControlCollection()
    var adjustControlsConstraints:[NSLayoutConstraint]!
    var adjustControlsImages:[[UIImage]]!
    var adjustControlsText:[[String]]!
    
    var filterControlsCollection:ControlCollection = ControlCollection()
    var filterControlsConstraints:[NSLayoutConstraint]!
    var filterControlsImages:[UIImage]!
    var filterControlsText:[String]!
    
    var lastCellIndexPath:IndexPath!
    var tappedIndexPath:IndexPath!
    
    var controlsStack:UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    var controlsStackConstraints:[NSLayoutConstraint]!
    
    var heightToMoveControls:CGFloat!
    var ylocation:CGFloat!
    var upylocation:CGFloat!

    var curFilter:CIFilter!
    //color controls: brightness contrast saturation
    //highlightshadow: highlights and shadows
    //exposureadjust: exposure
    //hueadjust: colors
    //remaining needed is intensity and temperature
   
    //var CIFilters:[CIFilter] = [CIFilter(name: "CIColorControls")!,  CIFilter(name: "CIExposureAdjust")!, CIFilter(name: "CISepiaTone")!, CIFilter(name: "CIHueAdjust")!, CIFilter(name: "CIVignette")!, CIFilter(name: "CIVibrance")!, CIFilter(name: "CIGloom")!]

    var descriptors:[[ScalarFilterParameter]] = []
    
    func getFilterParameterDescriptors() -> [ScalarFilterParameter] {
        let inputNames = (curFilter.inputKeys as [String]).filter { (parameterName) -> Bool in
            return (parameterName as String) != "inputImage"
        }
        
        let attributes = curFilter.attributes
        
        return inputNames.map { (inputName: String) -> ScalarFilterParameter in
            let attribute = attributes[inputName] as! [String : AnyObject]
            let displayName = inputName
            
            let minValue = attribute[kCIAttributeSliderMin] as! Float
            let maxValue = attribute[kCIAttributeSliderMax] as! Float
            let defaultValue = attribute[kCIAttributeDefault] as! Float
            
            return ScalarFilterParameter(name: displayName, key: inputName,
                                         minimumValue: minValue, maximumValue: maxValue, currentValue: defaultValue)
        }
        
    }

    
    func getKeys() {
        for i in 0 ..< appDelegate.singleton.filters.count {
            curFilter = appDelegate.singleton.filters[i]
            print(curFilter)
            descriptors.append(getFilterParameterDescriptors())
            print(descriptors[i].count)
            for descriptor in descriptors {
                print("      \(descriptor)")
            }
            print("\n")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
         applyyet = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        updateFilters()
        filteredImageView.inputImage = appDelegate.singleton.imagePicked
        
     

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        view.backgroundColor = UIColor.MNGray
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        getKeys()
        updateFilters()
        
        
        filteredImageView = FilteredImageView(frame: view.bounds)
        filteredImageView.inputImage = appDelegate.singleton.imagePicked
        filteredImageView.contentMode = .scaleAspectFit
        filteredImageView.clipsToBounds = true
        filteredImageView.translatesAutoresizingMaskIntoConstraints = false
        filteredImageView.backgroundColor = UIColor.MNBlack.withAlphaComponent(0.8)
        filteredImageView.delegate1 = self
        filteredImageView.filter = appDelegate.singleton.filters[0]
        filteredImageView.alpha = 0
        view.addSubview(filteredImageView)
        
        cropView = AKImageCropperView(frame: view.bounds)
        cropView.delegate = self
        cropView.image = appDelegate.singleton.imagePicked
        cropView.backgroundColor = UIColor.clear
        cropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropView)
        
        
        mainControlsImages = [#imageLiteral(resourceName: "move"),#imageLiteral(resourceName: "rgb-symbol"),#imageLiteral(resourceName: "settings-2"),#imageLiteral(resourceName: "bucket-with-paint")]
        mainControlsText = ["crop", "filters", "adjust", "paint"]
        
        cropControlsImages = [#imageLiteral(resourceName: "fit"),#imageLiteral(resourceName: "reload-4"),#imageLiteral(resourceName: "check")]
        cropControlsText = ["crop", "rotate", "finish"]
        
        paintControlsImages = [#imageLiteral(resourceName: "one-finger-click"),#imageLiteral(resourceName: "bucket-with-paint"),#imageLiteral(resourceName: "speech-bubble"),#imageLiteral(resourceName: "rotate-arrow")]
        paintControlsText = ["draw", "paint", "text", "undo"]
        
        adjustControlsImages = [[#imageLiteral(resourceName: "haze-1"),#imageLiteral(resourceName: "brightness-symbol"),#imageLiteral(resourceName: "contrast-symbol")],[#imageLiteral(resourceName: "pie-chart"), #imageLiteral(resourceName: "circular-frames"),#imageLiteral(resourceName: "star-1")], [#imageLiteral(resourceName: "cloudy-1")],[#imageLiteral(resourceName: "spray-bottle-with-dots") ],[#imageLiteral(resourceName: "snowflake")],[#imageLiteral(resourceName: "devil")]]
        adjustControlsText = [["saturation","brightness", "contrast"] ,["radius","shadows","highlights"], ["exposure"], ["colors"],["temperature"], ["intensity"]]
        
        filterControlsImages = [#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers")]
        filterControlsText = ["pack 0", "pack 1", "pack 2", "pack 3", "pack 4"]
        

        mainControlsCollection.dataSource = self
        mainControlsCollection.delegate = self
        cropControlsCollection.dataSource = self
        cropControlsCollection.delegate = self
        paintControlsCollection.dataSource = self
        paintControlsCollection.delegate = self
        adjustControlsCollection.dataSource = self
        adjustControlsCollection.delegate = self
        filterControlsCollection.dataSource = self
        filterControlsCollection.delegate = self
        
        

    
        imageViewConstraints = [
            filteredImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filteredImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filteredImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: appDelegate.navigationController.navigationBar.frame.height),
            filteredImageView.bottomAnchor.constraint(equalTo: controlsLayoutGuide.topAnchor),
            filteredImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        cropperImageViewConstraints = [
            cropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cropView.topAnchor.constraint(equalTo: view.topAnchor, constant: appDelegate.navigationController.navigationBar.frame.height + 10),
            cropView.bottomAnchor.constraint(equalTo: controlsLayoutGuide.topAnchor),
            cropView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        //TOP CONTROLS LAYOUT GUIDE
        controlsLayoutGuideConstraints = [
            controlsLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlsLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlsLayoutGuide.topAnchor.constraint(equalTo: filteredImageView.bottomAnchor),
            controlsLayoutGuide.bottomAnchor.constraint(equalTo: mainControlsLayoutGuide.topAnchor),
            controlsLayoutGuide.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        //STACKVIEW
        controlsStackConstraints = [
            controlsStack.centerXAnchor.constraint(equalTo: controlsLayoutGuide.centerXAnchor),
            controlsStack.bottomAnchor.constraint(equalTo: controlsLayoutGuide.bottomAnchor),
            controlsStack.topAnchor.constraint(equalTo: controlsLayoutGuide.topAnchor),
            controlsStack.heightAnchor.constraint(equalToConstant: 70),
            controlsStack.widthAnchor.constraint(equalTo: controlsLayoutGuide.widthAnchor)
            //controlsStack.widthAnchor.constraint(equalToConstant: 60*4 - 15)
        ]
        
        //CROP
        cropControlsConstraints = [
            cropControlsCollection.centerXAnchor.constraint(equalTo: controlsStack.centerXAnchor),
            cropControlsCollection.bottomAnchor.constraint(equalTo: controlsStack.bottomAnchor),
            cropControlsCollection.topAnchor.constraint(equalTo: controlsStack.topAnchor),
            cropControlsCollection.heightAnchor.constraint(equalToConstant: 70),
            cropControlsCollection.widthAnchor.constraint(equalToConstant: 60*4 + 55)
        ]
        //PAINT
        paintControlsConstraints = [
            paintControlsCollection.centerXAnchor.constraint(equalTo: controlsStack.centerXAnchor),
            paintControlsCollection.bottomAnchor.constraint(equalTo: controlsStack.bottomAnchor),
            paintControlsCollection.topAnchor.constraint(equalTo: controlsStack.topAnchor),
            paintControlsCollection.heightAnchor.constraint(equalToConstant: 70),
            paintControlsCollection.widthAnchor.constraint(equalToConstant: 60*4 + 55)
        ]
        //ADJUST
        let aw = adjustControlsCollection.widthAnchor.constraint(equalToConstant: 60*9 + 145)
        aw.priority = 749
        adjustControlsConstraints = [
            adjustControlsCollection.centerXAnchor.constraint(equalTo: controlsStack.centerXAnchor),
            adjustControlsCollection.bottomAnchor.constraint(equalTo: controlsStack.bottomAnchor),
            adjustControlsCollection.topAnchor.constraint(equalTo: controlsStack.topAnchor),
            adjustControlsCollection.heightAnchor.constraint(equalToConstant: 70),
            adjustControlsCollection.leadingAnchor.constraint(greaterThanOrEqualTo: controlsLayoutGuide.leadingAnchor),
            adjustControlsCollection.trailingAnchor.constraint(lessThanOrEqualTo: controlsLayoutGuide.trailingAnchor),
            aw
        ]
        //FILTER
        let fw = filterControlsCollection.widthAnchor.constraint(equalToConstant: 60*9 + 145)
        fw.priority = 749
        filterControlsConstraints = [
            filterControlsCollection.centerXAnchor.constraint(equalTo: controlsStack.centerXAnchor),
            filterControlsCollection.bottomAnchor.constraint(equalTo: controlsStack.bottomAnchor),
            filterControlsCollection.topAnchor.constraint(equalTo: controlsStack.topAnchor),
            filterControlsCollection.heightAnchor.constraint(equalToConstant: 70),
            filterControlsCollection.leadingAnchor.constraint(greaterThanOrEqualTo: controlsLayoutGuide.leadingAnchor),
            filterControlsCollection.trailingAnchor.constraint(lessThanOrEqualTo: controlsLayoutGuide.trailingAnchor),
            fw
        ]
       
        //
        //BOTTOM CONTROLS LAYOUT GUIDE
        mainControlsLayoutGuideConstraints = [
            mainControlsLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainControlsLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainControlsLayoutGuide.topAnchor.constraint(equalTo: controlsLayoutGuide.bottomAnchor),
            mainControlsLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainControlsLayoutGuide.heightAnchor.constraint(equalToConstant: 70)
        ]
        //MAIN CONTROLS
        mainControlsConstraints = [
            mainControlsCollection.centerXAnchor.constraint(equalTo: mainControlsLayoutGuide.centerXAnchor),
            mainControlsCollection.bottomAnchor.constraint(equalTo: mainControlsLayoutGuide.bottomAnchor),
            mainControlsCollection.topAnchor.constraint(equalTo: mainControlsLayoutGuide.topAnchor),
            mainControlsCollection.heightAnchor.constraint(equalToConstant: 70),
            mainControlsCollection.widthAnchor.constraint(equalToConstant: 60*4 + 55)
        ]
        
        
        view.addLayoutGuide(mainControlsLayoutGuide)
        view.addLayoutGuide(controlsLayoutGuide)
        view.addSubview(controlsStack)
        view.addSubview(mainControlsCollection)
        
        controlsStack.addSubview(cropControlsCollection)
        controlsStack.addSubview(paintControlsCollection)
        controlsStack.addSubview(adjustControlsCollection)
        controlsStack.addSubview(filterControlsCollection)
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(cropperImageViewConstraints)
        NSLayoutConstraint.activate(controlsLayoutGuideConstraints)
        NSLayoutConstraint.activate(controlsStackConstraints)
        
        NSLayoutConstraint.activate(cropControlsConstraints)
        NSLayoutConstraint.activate(paintControlsConstraints)
        NSLayoutConstraint.activate(adjustControlsConstraints)
        NSLayoutConstraint.activate(filterControlsConstraints)
        
        NSLayoutConstraint.activate(mainControlsLayoutGuideConstraints)
        NSLayoutConstraint.activate(mainControlsConstraints)

        showControls(cvTag: 0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        showControls(cvTag: 0)
    }

    
    func showControls(cvTag:Int) {
        
        var hideTheseCollections:[ControlCollection] = []
        var showThisCollection:ControlCollection!
        
        switch cvTag {
        case 0:
            hideTheseCollections = [self.paintControlsCollection, self.adjustControlsCollection, self.filterControlsCollection]
            showThisCollection = cropControlsCollection
        case 1:
            hideTheseCollections = [self.cropControlsCollection, self.paintControlsCollection, self.adjustControlsCollection]
            showThisCollection = self.filterControlsCollection
        case 2:
            hideTheseCollections = [self.cropControlsCollection, self.paintControlsCollection, self.filterControlsCollection]
            showThisCollection = self.adjustControlsCollection
        case 3:
            hideTheseCollections = [self.cropControlsCollection, self.adjustControlsCollection, self.filterControlsCollection]
            showThisCollection = self.paintControlsCollection
        default:
            break
        }
        
        showThisCollection.transform = CGAffineTransform(translationX: 0, y: -showThisCollection.frame.height)
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                for c in hideTheseCollections {
                    c.isHidden = true
                    c.alpha = 0
                }
                showThisCollection.transform = CGAffineTransform(translationX: 0, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3, animations: {
                showThisCollection.isHidden = false
                showThisCollection.alpha = 1
            })
        }, completion: { finished in
            
        })
        
        //blue color on selected main control
        let cell = mainControlsCollection.cellForItem(at: IndexPath(row: cvTag, section: 0))
        cell?.alpha = 1
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                cell?.alpha = 1
                if self.lastCellIndexPath != nil {
                    let previousCell = self.mainControlsCollection.cellForItem(at: self.lastCellIndexPath)
                    previousCell?.backgroundColor = UIColor.clear
                }
                cell?.backgroundColor = UIColor.MNLighterBlue
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5, animations: {
                cell?.alpha = 1
                
            })
        }, completion: nil)
        lastCellIndexPath = IndexPath(row: cvTag, section: 0)
        
        
    }
}


extension EditController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == adjustControlsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adjustcontrol", for: indexPath) as! AdjustControlCell
            
            cell.imageView.image = adjustControlsImages[indexPath.section][indexPath.item].withRenderingMode(.alwaysTemplate)
            cell.label.text = adjustControlsText[indexPath.section][indexPath.item]
            cell.filterLocation = indexPath.section

            cell.scalarFilterParam = descriptors[indexPath.section][indexPath.item]
        
            cell.layer.cornerRadius = 5
            cell.delegate = filteredImageView
          
            cell.awakeFromNib()
            
            return cell
            
        }
        else if collectionView == filterControlsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterpackcontrol", for: indexPath) as! FilterPackControlCell
            cell.imageView.image = filterControlsImages[indexPath.item].withRenderingMode(.alwaysTemplate)
            cell.label.text = filterControlsText[indexPath.item]
            cell.filterPack = filterObjects[indexPath.item]
            cell.delegate = self
            cell.awakeFromNib()
            cell.layer.cornerRadius = 5
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "control", for: indexPath) as! ControlCell
            cell.awakeFromNib()
            if collectionView == mainControlsCollection {
                cell.imageView.image = mainControlsImages[indexPath.item].withRenderingMode(.alwaysTemplate)
                cell.label.text = mainControlsText[indexPath.item]
            }
            if collectionView == cropControlsCollection {
                cell.imageView.image = cropControlsImages[indexPath.item].withRenderingMode(.alwaysTemplate)
                cell.label.text = cropControlsText[indexPath.item]
            }
            if collectionView == paintControlsCollection {
                cell.imageView.image = paintControlsImages[indexPath.item].withRenderingMode(.alwaysTemplate)
                cell.label.text = paintControlsText[indexPath.item]
            }
            cell.layer.cornerRadius = 5
            return cell
        }


        let cell:UICollectionViewCell!
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if tappedIndexPath != nil && tappedIndexPath == indexPath {
            if collectionView == filterControlsCollection {
                let numFiltersInPack:CGFloat = CGFloat(filterObjects[indexPath.item].count) + 1
                print(numFiltersInPack)
                return CGSize(width: (60 * numFiltersInPack + 15 * (numFiltersInPack - 1)), height: 60)
            }
            if collectionView == adjustControlsCollection {
                return CGSize(width: (60*4), height: 60)
            }
        }
        return CGSize(width: 60, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == adjustControlsCollection {
            if section == 0 {
                        print("descriptionsatsection.count: \(descriptors[section].count)")
                return descriptors[section].count // should be 3
            }
            if section == 1 {
                        print("descriptionsatsection.count: \(descriptors[section].count)")
                return descriptors[section].count // should be 3
            }
            if section == 2 {
                        print("descriptionsatsection.count: \(descriptors[section].count)")
                return descriptors[section].count // should be 1
            }
            if section == 3 {
                 print("descriptionsatsection.count: \(descriptors[section].count)")
                return descriptors[section].count // should be 1
            }
        }
        if collectionView == filterControlsCollection {
            return filterObjects.count
        }
        if collectionView == cropControlsCollection {
            return 3
        }
        return 4
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == adjustControlsCollection {
            print("descriptions.count: \(descriptors.count)")
            return descriptors.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            cell?.alpha = 1
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainControlsCollection {
            switch indexPath.item {
            case 0:
                showControls(cvTag: 0)
            case 1:
                showControls(cvTag: 1)
            case 2:
                showControls(cvTag: 2)
            case 3:
                showControls(cvTag: 3)
            default:
                break
            }
        }
        
        if collectionView == cropControlsCollection {
            switch indexPath.item {
            case 0:
                showHideOverlayAction()
            case 1:
                rotateAction()
            case 2:
                cropImageAction()
            default:
                break
            }
        }
        
        if tappedIndexPath != nil && tappedIndexPath == indexPath {
            tappedIndexPath = nil
        } else {
            tappedIndexPath = indexPath
        }
        
        if collectionView == filterControlsCollection || collectionView == adjustControlsCollection {
            collectionView.performBatchUpdates({
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }, completion: nil)
            
            if collectionView == adjustControlsCollection {
                filteredImageView.filter = appDelegate.singleton.filters[indexPath.section]
            }
       
        }

    }

    
    func apply(_ filter: CIFilter?, for image: CIImage) -> CIImage {
        guard let filter = filter else { return image }
        filter.setValue(image, forKey: kCIInputImageKey)
        guard let filteredImage = filter.value(forKey: kCIOutputImageKey) else { return image }
        return filteredImage as! CIImage
    }

    
    
}


extension EditController {
    func createFilters(createfilters:[String], createnames:[String]) -> [filterObj] {
        var newFilters:[filterObj] = []
        
        for i in 0..<createfilters.count {
            
            // Create filters for each button
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: appDelegate.singleton.imagePicked) //cropView.image!
            let filter = CIFilter(name: "\(createfilters[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            
            newFilters.append(filterObj(name: createnames[i], image: imageForButton))
        }
        
        return newFilters
    }
    
    func updateFilters() {
        let filterPack0:[String] = ["CIPhotoEffectChrome","CIPhotoEffectFade"]
        let filterPack1:[String] = ["CIPhotoEffectProcess"]
        let filterPack2:[String] = ["CIPhotoEffectTonal"]
        let filterPack3:[String] = ["CIPhotoEffectTransfer","CIPhotoEffectNoir"]
        let filterPack4:[String] = ["CISepiaTone","CIPhotoEffectInstant"]
        
        
        let filterNames0:[String] = ["chrome","fade"]
        let filterNames1:[String] = ["process"]
        let filterNames2:[String] = ["tonal"]
        let filterNames3:[String] = ["transfer", "noir"]
        let filterNames4:[String] = ["sepia", "instant"]
        
        
        //rose filter pack
        //....
        
        //sunny filter pack
        //....
  
        
        filterObjects = [ createFilters(createfilters: filterPack0, createnames: filterNames0),
                          createFilters(createfilters: filterPack1, createnames: filterNames1),
                          createFilters(createfilters: filterPack2, createnames: filterNames2),
                          createFilters(createfilters: filterPack3, createnames: filterNames3),
                          createFilters(createfilters: filterPack4, createnames: filterNames4)
                        ]
        
 
      if applyyet
      {
        filterControlsCollection.performBatchUpdates({
            self.filterControlsCollection.collectionViewLayout.invalidateLayout()
            
            for i in 0 ..< filterObjects.count {
                self.filterControlsCollection.deleteItems(at: [IndexPath(row: i, section: 0)])
            }
            for i in 0 ..< filterObjects.count {
                self.filterControlsCollection.insertItems(at: [IndexPath(row: i, section: 0)])
            }
            
        }, completion: nil)
      }

    
    }
    

    
}

var filterObjects:[[filterObj]] = []

struct filterContainerObj {
    var name:String!
    var image:UIImage!
    var filters:[filterObj] = []
}

struct filterObj {
    var name:String!
    var image:UIImage!
}
