//
//  CameraController.swift
//  colormeapp
//
//  Created by Max Nelson on 5/22/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit

class CameraController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var singleton = ColorMeSingleton.sharedInstance
    var appDelegate:AppDelegate!
    var background:UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        if singleton.imageNotPicked {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = true
                imagePicker.showsCameraControls = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            singleton.imageNotPicked = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        background = UIImageView(frame: view.frame)
        background.image = #imageLiteral(resourceName: "IMG_0534")
        background.backgroundColor = UIColor.MNGray
        background.contentMode = .scaleAspectFill
        background.transform = CGAffineTransform(scaleX: 5, y: 5)
        view.addSubview(background)
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        vev.layer.cornerRadius = 0
        vev.layer.masksToBounds = true
        vev.frame = view.frame
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        background.addSubview(vev)
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        view.backgroundColor = UIColor.MNGray
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {
            self.appDelegate.goToMenuController()
        })
    }
    //save the selected or taken image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("original")
            singleton.imagePicked = img
        } else {
            print("not an image")
        }
        self.dismiss(animated: true, completion: {
            self.appDelegate.goToMenuController()
            self.appDelegate.goToEditController()
        })
    }
    


}
