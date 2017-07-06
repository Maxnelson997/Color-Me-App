//
//  EditController.swift
//  colormeapp
//
//  Created by Max Nelson on 5/21/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit
import AKImageCropperView
import PopupDialog

extension EditController: UIImagePickerControllerDelegate {
    
    //alternate way of saving images
//    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            // we got back an error!
//            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        } else {
//            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//        }
//    }
//    
//    
//    func saveImage() {
//        let imageData = imageToSave.generateJPEGRepresentation()
//        let compressedJPGImage = UIImage(data: imageData)
////        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
    
    //optimal way of saving images
    func share(sender:UIButton) -> Void {
        
        let btn = UIBarButtonItem(customView: sender)
        //apply the drawings to the image right quick

   
        let sz = imageToSave.size
        UIGraphicsBeginImageContextWithOptions(sz, false, 0.0)
        imageToSave.draw(in: CGRect.init(x: 0, y: 0, width: sz.width, height: sz.height))
        drawImg.image?.draw(in: CGRect.init(x: 0, y: 0, width: sz.width, height: sz.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        imageToSave = img!
        UIGraphicsEndImageContext()
 
        
        //unk now we can save yu guys
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [UIImage(data: imageToSave.generateJPEGRepresentation())!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = (btn)
        activityViewController.modalPresentationStyle = .popover
        self.present(activityViewController, animated: true, completion: { })
        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                
                self.pop = PopupDialog(title: "Success", message: "image successfuly shared/saved")
                self.present(self.pop, animated: true, completion: {
                    
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.pop.dismiss()
                })
                
            } else {
                
                self.pop = PopupDialog(title: "Cancelled/Error", message: "User cancelled or an error occured")
                self.present(self.pop, animated: true, completion: {
                    
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    self.pop.dismiss()
                })
                
            }
        }
        
    }
    
}
extension UIImage {
    
    /**
     Creates the UIImageJPEGRepresentation out of an UIImage
     @return Data
     */
    
    func generateJPEGRepresentation() -> Data {
        
        let newImage = self.copyOriginalImage()
        let newData = UIImageJPEGRepresentation(newImage, 0.75)
        
        return newData!
    }
    
    /**
     Copies Original Image which fixes the crash for extracting Data from UIImage
     @return UIImage8
     */
    
    private func copyOriginalImage() -> UIImage {
        UIGraphicsBeginImageContext(self.size);
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage!
    }
}
extension EditController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        print("New crop rectangle: \(rect)")
    }
    
    func cropImageAction() {
        if cropView.isOverlayViewActive {
            singleton.imagePicked = cropView.croppedImageToUse!
            cropView.hideOverlayView(animationDuration: 0)
            cropView.setInteraction = false
            updateFilters()
            filteredImageView.setNeedsLayout()
            NSLayoutConstraint.deactivate(cropperImageViewConstraints)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {

                self.size = self.cropView.croppedSize.size
                self.cropConstraints()
            })

            
        }
    }
    
    func showHideOverlayAction() {
        
        if cropView.isOverlayViewActive {
            cropView.hideOverlayView(animationDuration: 0.3)
            cropView.setInteraction = false
        } else {
//               resetAction()
            cropView.showOverlayView(animationDuration: 0.3)
            cropView.setInteraction = true
        
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
    
    func removeEffects() {
        singleton.imagePicked = self.veryOriginalImage
        updateFilters()
        filteredImageView.resetFilters()
        filteredImageView.currentAppliedFilter = "reset"
        
        
        self.pop = PopupDialog(title: "Changes Reverted", message: "All filters, edits, and drawings removed.")
        self.present(self.pop, animated: true, completion: {
            
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.pop.dismiss()
        })
        
    }
    
    func resetAction() {
        singleton.imagePicked = self.veryOriginalImage
        cropView.reset(animationDuration: 0)
        angle = 0.0

        filteredImageView.setNeedsLayout()
        NSLayoutConstraint.deactivate(cropperImageViewConstraints)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.size = self.resetOriginalSize
            print(self.size)
            self.cropConstraints()
        })
    }
    
    
}

class EditController: UIViewController, SetFilter {
    var angle: Double = 0.0
    var applyyet:Bool = false
    var resetOriginalSize:CGSize!
    var veryOriginalImage:UIImage!
    var singleton = ColorMeSingleton.sharedInstance
    var imageToSave:UIImage!
    var pop:PopupDialog = PopupDialog(title: "hi", message: "pls wait.")
    func ApplyToCropView(image: UIImage!) {
        self.cropView.image = image
        self.imageToSave = image
        print("edited image applied to cropview")
    }
    
    func ApplyFilter(filter: UIImage!, name: String!) {
        //        singleton.imagePicked = filter
        filteredImageView.currentAppliedFilter = name
        filteredImageView.setNeedsLayout()
    }
    
    func backTappedToCloseCV() {
        tappedIndexPath = nil
        filterControlsCollection.performBatchUpdates({
         //   self.filterControlsCollection.collectionViewLayout.invalidateLayout()
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
        for i in 0 ..< singleton.filters.count {
            curFilter = singleton.filters[i]
            print(curFilter)
            descriptors.append(getFilterParameterDescriptors())
            //  print(descriptors[i].count)
            
            print("\n")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        applyyet = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        updateFilters()
        filteredImageView.inputImage = singleton.imagePicked
        
        
        
    }
    var lastPoint = CGPoint.zero
    var swiped = false
    
    var red:CGFloat = 0.4
    var green:CGFloat = 0.6
    var blue:CGFloat = 1.0
    var brushSize:CGFloat = 4.0
    let lineWidth:CGFloat = 4.0
    var opacityValue:CGFloat = 1.0
    var finalPoint: CGPoint!
    var tool:UIImageView!
    var paintTabActive = false
    var selectedImage:UIImage!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if paintTabActive {
            if let e = event?.touches(for: self.cropView){
                if let touch = e.first {
                    finalPoint = touch.preciseLocation(in: self.cropView)
                }
            }
        }
    }

    var size:CGSize!
    var imHeight:CGFloat!
    var imWidth:CGFloat!

    var topY:CGFloat!
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext((cropView.image?.size)!)
        
//        UIGraphicsBeginImageContext(cropView.frame.size)
//        cropView.image?.draw(in: CGRect(x: 0, y: 0, width: cropView.frame.width, height: cropView.frame.height)) // + ((cropView.frame.height - imCondensedSize.height)/2)
//        cropView.image?.draw(in: CGRect(x: 0, y: 0, width: (cropView.image?.size.width)!, height: (cropView.image?.size.height)!))
        let context = UIGraphicsGetCurrentContext()
        var ratio:CGFloat = 0
        if (cropView.image?.size.width)! > (cropView.image?.size.height)! {
           ratio = (cropView.image?.size.width)! / (cropView.image?.size.height)!
        } else {
            ratio = (cropView.image?.size.height)! / (cropView.image?.size.width)!
        }
        
        context?.move(to: CGPoint(x: fromPoint.x * ratio, y: fromPoint.y * ratio))
        context?.addLine(to: CGPoint(x: toPoint.x * ratio, y: toPoint.y * ratio))
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        
        context?.strokePath()
        let img = UIGraphicsGetImageFromCurrentImageContext()

        ApplyToCropView(image: img)
//                filteredImageView.inputImage = img
       
        UIGraphicsEndImageContext()

        print("topy: \(topY)")



        
        print(self.cent)
    }
    var drawImg:UIImageView = UIImageView()
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isDrawing = true
        if paintTabActive {
            if let e = event?.touches(for: self.cropView){
                if let touch = e.first{
                    if let d = self.cropView {
                        
                        let currentCoordinate = touch.preciseLocation(in: d)
                        //UIGraphicsBeginImageContext(d.bounds.size)
                        UIGraphicsBeginImageContextWithOptions(d.bounds.size, false, 0.0)
                        drawImg.image?.draw(in: CGRect.init(x: 0, y: 0, width: d.bounds.width, height: d.bounds.height))
                        UIGraphicsGetCurrentContext()?.move(to: finalPoint)
                        UIGraphicsGetCurrentContext()?.addLine(to: currentCoordinate)
                        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
                        UIGraphicsGetCurrentContext()?.setLineWidth(lineWidth)
                        UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                        UIGraphicsGetCurrentContext()?.strokePath()
                        let img = UIGraphicsGetImageFromCurrentImageContext()
                        //                    singleton.imagePicked = img!
                        //                    singleton.drawnImage = img!
                        drawImg.image = img!
                        //                    ApplyToCropView(image: img)
                        //no,will combine image at save.
                        //                    filteredImageView.setNeedsLayout()
                        
                        UIGraphicsEndImageContext()
                        finalPoint = currentCoordinate
                    }
                }
            }
        }

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        finalPoint = CGPoint(x: 1, y: 1)
//        if paintTabActive {
//            if touches.first?.view == self.view {
//                
//            } else {
//                if !swiped {
//                    drawLines(fromPoint: lastPoint, toPoint: lastPoint)
//                }
//            }
//        }


    }
    func cropConstraints() {
//        cropView.backgroundColor = UIColor.cyan
        //reset draw img..
        self.drawImg.image = UIImage()

        print(size)
        
        if size.height > size.width {
            //slim
            imWidth = self.view.frame.width * 0.9 * (size.width/size.height)
            imHeight = imWidth * (size.height/size.width)
            
            cropperImageViewConstraints = [
                
                centG.topAnchor.constraint(equalTo: view.topAnchor, constant: appDelegate.navigationController.navigationBar.frame.height),
                centG.bottomAnchor.constraint(equalTo: controlsLayoutGuide.topAnchor),
                centG.leftAnchor.constraint(equalTo: view.leftAnchor),
                centG.rightAnchor.constraint(equalTo: view.rightAnchor),
                
                cropView.centerXAnchor.constraint(equalTo: centG.centerXAnchor),
                cropView.centerYAnchor.constraint(equalTo: centG.centerYAnchor),
                cropView.heightAnchor.constraint(equalTo: centG.heightAnchor, multiplier: 1),
                cropView.widthAnchor.constraint(equalTo: centG.heightAnchor, multiplier: (imWidth/imHeight)),
                
                drawImg.centerXAnchor.constraint(equalTo: centG.centerXAnchor),
                drawImg.centerYAnchor.constraint(equalTo: centG.centerYAnchor),
                drawImg.heightAnchor.constraint(equalTo: cropView.heightAnchor),
                drawImg.widthAnchor.constraint(equalTo: cropView.widthAnchor),
            ]
            
        } else {
            //wide
            imHeight = self.view.frame.width * 0.9 * (size.height/size.width)
            imWidth = imHeight * (size.width/size.height)
            
            cropperImageViewConstraints = [
                
                centG.topAnchor.constraint(equalTo: view.topAnchor, constant: appDelegate.navigationController.navigationBar.frame.height),
                centG.bottomAnchor.constraint(equalTo: controlsLayoutGuide.topAnchor),
                centG.leftAnchor.constraint(equalTo: view.leftAnchor),
                centG.rightAnchor.constraint(equalTo: view.rightAnchor),
                cropView.centerXAnchor.constraint(equalTo: centG.centerXAnchor),
                cropView.centerYAnchor.constraint(equalTo: centG.centerYAnchor),
                cropView.widthAnchor.constraint(equalTo: centG.widthAnchor, multiplier: 1),
                cropView.heightAnchor.constraint(equalTo: centG.widthAnchor, multiplier: (imHeight/imWidth)),
                drawImg.centerXAnchor.constraint(equalTo: centG.centerXAnchor),
                drawImg.centerYAnchor.constraint(equalTo: centG.centerYAnchor),
                drawImg.heightAnchor.constraint(equalTo: cropView.heightAnchor),
                drawImg.widthAnchor.constraint(equalTo: cropView.widthAnchor),
                
                
                
            ]
            
        }
        
        NSLayoutConstraint.activate(cropperImageViewConstraints)
    }
    var centG:UILayoutGuide!
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomFilterManager.registerFilters()
        
        view.backgroundColor = UIColor.MNGray
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        veryOriginalImage = singleton.imagePicked
//        drawImg.image = self.veryOriginalImage
        drawImg.translatesAutoresizingMaskIntoConstraints = false
        getKeys()
        updateFilters()
        
        filteredImageView = FilteredImageView(frame: view.bounds)
        filteredImageView.inputImage = singleton.imagePicked
        filteredImageView.contentMode = .scaleAspectFit
        filteredImageView.clipsToBounds = true
        filteredImageView.translatesAutoresizingMaskIntoConstraints = false
        filteredImageView.backgroundColor = UIColor.MNBlack.withAlphaComponent(0.8)
        filteredImageView.delegate1 = self
        filteredImageView.filter = singleton.filters[0]
        filteredImageView.alpha = 0
        view.addSubview(filteredImageView)
        
        cropView = AKImageCropperView(frame: view.bounds)
        cropView.delegate = self
        cropView.image = singleton.imagePicked
        cropView.imageToCrop = self.veryOriginalImage
        cropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cropView)
        view.addSubview(drawImg)
//        cropView.isUserInteractionEnabled = false
        
        mainControlsImages = [#imageLiteral(resourceName: "reload-2"),#imageLiteral(resourceName: "move"),#imageLiteral(resourceName: "rgb-symbol"),#imageLiteral(resourceName: "settings-2"),#imageLiteral(resourceName: "bucket-with-paint")]
        mainControlsText = ["reset all","crop", "filters", "adjust", "color"]
        
        cropControlsImages = [#imageLiteral(resourceName: "reload-2") ,#imageLiteral(resourceName: "fit"),#imageLiteral(resourceName: "reload-4"),#imageLiteral(resourceName: "check")]
        cropControlsText = ["reset", "crop", "rotate", "finish"]
        //
        //        paintControlsImages = [#imageLiteral(resourceName: "one-finger-click"),#imageLiteral(resourceName: "bucket-with-paint"),#imageLiteral(resourceName: "speech-bubble"),#imageLiteral(resourceName: "rotate-arrow")]
        //        paintControlsText = ["draw", "paint", "text", "undo"]

        
        paintControlsImages = [#imageLiteral(resourceName: "reload-2"),#imageLiteral(resourceName: "one-finger-click"),#imageLiteral(resourceName: "one-finger-click"),#imageLiteral(resourceName: "one-finger-click"), #imageLiteral(resourceName: "one-finger-click"),#imageLiteral(resourceName: "one-finger-click"),#imageLiteral(resourceName: "one-finger-click")]
        paintControlsText = ["reset", "sky", "pink", "red", "white", "blue", "black"]

        adjustControlsImages = [[#imageLiteral(resourceName: "haze-1"),#imageLiteral(resourceName: "brightness-symbol"),#imageLiteral(resourceName: "contrast-symbol")],[#imageLiteral(resourceName: "pie-chart"), #imageLiteral(resourceName: "circular-frames"),#imageLiteral(resourceName: "star-1")], [#imageLiteral(resourceName: "cloudy-1")],[#imageLiteral(resourceName: "spray-bottle-with-dots") ],[#imageLiteral(resourceName: "snowflake")],[#imageLiteral(resourceName: "devil")]]
        adjustControlsText = [["saturation","brightness", "contrast"] ,["radius","shadows","highlights"], ["exposure"], ["colors"],["temperature"], ["intensity"]]
        
        filterControlsImages = [#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers"),#imageLiteral(resourceName: "three-layers")]
        filterControlsText = ["super","summer", "sunlit" ,"shady", "glow", "cartoon"]

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
        
        
        centG = UILayoutGuide()
        view.addLayoutGuide(centG)
        
        imageViewConstraints = [
            filteredImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filteredImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filteredImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: appDelegate.navigationController.navigationBar.frame.height),
            filteredImageView.bottomAnchor.constraint(equalTo: controlsLayoutGuide.topAnchor),
            filteredImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        let pw = paintControlsCollection.widthAnchor.constraint(equalToConstant: 60*9 + 145)
        pw.priority = 749
        paintControlsConstraints = [
            paintControlsCollection.centerXAnchor.constraint(equalTo: controlsStack.centerXAnchor),
            paintControlsCollection.bottomAnchor.constraint(equalTo: controlsStack.bottomAnchor),
            paintControlsCollection.topAnchor.constraint(equalTo: controlsStack.topAnchor),
            paintControlsCollection.heightAnchor.constraint(equalToConstant: 70),
            paintControlsCollection.leadingAnchor.constraint(greaterThanOrEqualTo: controlsLayoutGuide.leadingAnchor),
            paintControlsCollection.trailingAnchor.constraint(lessThanOrEqualTo: controlsLayoutGuide.trailingAnchor),
            pw
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
            mainControlsCollection.widthAnchor.constraint(equalToConstant: 60*5 + 80)
        ]
        
        
        view.addLayoutGuide(mainControlsLayoutGuide)
        view.addLayoutGuide(controlsLayoutGuide)
        view.addSubview(controlsStack)
        view.addSubview(mainControlsCollection)
        
        controlsStack.addSubview(cropControlsCollection)
        controlsStack.addSubview(paintControlsCollection)
        controlsStack.addSubview(adjustControlsCollection)
        controlsStack.addSubview(filterControlsCollection)
        size = (self.cropView.image?.size)!

        cropConstraints()
        
        NSLayoutConstraint.activate(imageViewConstraints)
//        NSLayoutConstraint.activate(cropperImageViewConstraints)
        NSLayoutConstraint.activate(controlsLayoutGuideConstraints)
        NSLayoutConstraint.activate(controlsStackConstraints)
        
        NSLayoutConstraint.activate(cropControlsConstraints)
        NSLayoutConstraint.activate(paintControlsConstraints)
        NSLayoutConstraint.activate(adjustControlsConstraints)
        NSLayoutConstraint.activate(filterControlsConstraints)
        
        NSLayoutConstraint.activate(mainControlsLayoutGuideConstraints)
        NSLayoutConstraint.activate(mainControlsConstraints)
        
        showControls(cvTag: 1)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            self.resetOriginalSize = self.cropView.frame.size
        })
 
        self.cent = self.cropView.center
//        cropView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    var cent:CGPoint!
    
    override func viewDidDisappear(_ animated: Bool) {
        showControls(cvTag: 1)
    }
    
    
    func showControls(cvTag:Int) {
        var hideTheseCollections:[ControlCollection] = []
        var showThisCollection:ControlCollection!
        
        switch cvTag {
        case 1:
            hideTheseCollections = [self.paintControlsCollection, self.adjustControlsCollection, self.filterControlsCollection]
            showThisCollection = cropControlsCollection
            paintTabActive = false
        case 2:
            hideTheseCollections = [self.cropControlsCollection, self.paintControlsCollection, self.adjustControlsCollection]
            showThisCollection = self.filterControlsCollection
            paintTabActive = false
        case 3:
            hideTheseCollections = [self.cropControlsCollection, self.paintControlsCollection, self.filterControlsCollection]
            showThisCollection = self.adjustControlsCollection
            paintTabActive = false
        case 4:
            paintTabActive = true
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
        UIView.animateKeyframes(withDuration: 0.8, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                cell?.alpha = 1
                if self.lastCellIndexPath != nil {
                    let previousCell = self.mainControlsCollection.cellForItem(at: self.lastCellIndexPath)
                    previousCell?.backgroundColor = UIColor.clear
                }
                cell?.backgroundColor = UIColor.white
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
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
                print(CGSize(width: (60 * numFiltersInPack + 15 * (numFiltersInPack - 1)), height: 60))
                let cell = filterControlsCollection.cellForItem(at: indexPath)
                cell?.awakeFromNib()
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
            return 4
        }
        if collectionView == paintControlsCollection {
            return paintControlsText.count
        }
        if collectionView == mainControlsCollection {
            return mainControlsText.count
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
                //reset all filters adjust values and crops
                resetAction()
                removeEffects()
            case 1:
                showControls(cvTag: 1)
            case 2:
                showControls(cvTag: 2)
            case 3:
                showControls(cvTag: 3)
            case 4:
                showControls(cvTag: 4)
            default:
                break
            }
        }
        
        if collectionView == cropControlsCollection {
            switch indexPath.item {
            case 0:
                self.pop = PopupDialog(title: "Crop Removed", message: "Crops removed.")
                self.present(self.pop, animated: true, completion: {
                    
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                    self.pop.dismiss()
                })
                resetAction()
            case 1:
                showHideOverlayAction()
            case 2:
                rotateAction()
            case 3:
                cropImageAction()
            default:
                break
            }
        }
        
        if collectionView == paintControlsCollection {
            if indexPath.item != 0 { //does not equal 0. we dont want to animate the reset button
                let cell = paintControlsCollection.cellForItem(at: IndexPath(row: indexPath.item, section: 0))
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
                    for i in 0 ..< self.paintControlsText.count {
                        if i != indexPath.item {
                            let cell = self.paintControlsCollection.cellForItem(at: IndexPath(row: i, section: 0))
                            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }
                    }
                    cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: nil)
            }

            switch indexPath.item {
            case 0:
                //reset control
                drawImg.image = UIImage()
                self.pop = PopupDialog(title: "Drawings Removed", message: "RIP to your drawings.")
                self.present(self.pop, animated: true, completion: {
                    
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
                    self.pop.dismiss()
                })
            case 1:
                //sky
                red = 0.4
                green = 0.6
                blue = 1
            case 2:

                //pink
                red = 1
                green = 0.4
                blue = 0.6
            case 3:
                //red
                red = 1
                green = 0
                blue = 0

            case 4:
                //white
                red = 1
                green = 1
                blue = 1
            case 5:
                //blue
                red = 0
                green = 0
                blue = 1
            case 6:
                //black
                red = 0
                green = 0
                blue = 0
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
             //   collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }, completion: nil)
            
            if collectionView == adjustControlsCollection {
                filteredImageView.filter = singleton.filters[indexPath.section]
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
            let coreImage = CIImage(image: singleton.imagePicked) //cropView.image!
            let filter = CIFilter(name: "\(createfilters[i])" )
            print(createfilters[i])
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!)
            
            newFilters.append(filterObj(name: createnames[i], image: imageForButton, filterName: createfilters[i]))
        }
        
        return newFilters
    }
    
    func updateFilters() {
//        let filterPack0:[String] = ["CIPhotoEffectChrome","CIPhotoEffectFade"]
//        let filterPack1:[String] = ["CIPhotoEffectProcess"]
//        let filterPack2:[String] = ["CIPhotoEffectTonal"]
//        let filterPack3:[String] = ["CIPhotoEffectTransfer","CIPhotoEffectNoir"]
//        let filterPack4:[String] = ["CISepiaTone","CIPhotoEffectInstant"]
//        let customPack1:[String] = ["MNEdgeGlow", "MNKuwahara"]
//        
//        
//        let filterNames0:[String] = ["chrome","fade"]
//        let filterNames1:[String] = ["process"]
//        let filterNames2:[String] = ["tonal"]
//        let filterNames3:[String] = ["transfer", "noir"]
//        let filterNames4:[String] = ["sepia", "instant"]
//        let customNames1:[String] = ["bronze", "Kuwahara"]
        let super_pack:[String] = ["CIPhotoEffectProcess"]
        let summer_pack:[String] = ["CISepiaTone", "CIPhotoEffectTransfer", "CIPhotoEffectInstant", "CIPhotoEffectFade"]
        let sunlit_pack:[String] = ["CIPhotoEffectChrome"]
        let shady_pack:[String] = ["CIPhotoEffectNoir", "CIPhotoEffectTonal"]
        let glow_pack:[String] = ["MNEdgeGlow", "MNMono", "MNSmoothThreshold"]
        let cartoon_pack:[String] = ["MNKuwahara"]
        
        
        let super_names:[String] = ["double"]
        let summer_names:[String] = ["plastic", "nitefest", "berry", "sinking"]
        let sunlit_names:[String] = ["blaze"]
        let shady_names:[String] = ["elayno","nitetone"]
        let glow_names:[String] = ["trimmed", "space", "smooth"]
        let cartoon_names:[String] = ["cartoon"]
        
        //rose filter pack
        //....
        
        //sunny filter pack
        //....
        
        
        filterObjects = [ createFilters(createfilters: super_pack, createnames: super_names),
                          createFilters(createfilters: summer_pack, createnames: summer_names),
                          createFilters(createfilters: sunlit_pack, createnames: sunlit_names),
                          createFilters(createfilters: shady_pack, createnames: shady_names),
                          createFilters(createfilters: glow_pack, createnames: glow_names),
                          createFilters(createfilters: cartoon_pack, createnames: cartoon_names)
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
    var filterName:String!
}
