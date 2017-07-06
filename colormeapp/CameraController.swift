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
//
//    var pop:PopupDialog = PopupDialog(title: "hi", message: "pls wait.")
    
    override func viewDidDisappear(_ animated: Bool) {
//        if singleton.didTakePic {
//            self.pop = PopupDialog(title: "Picture Taken", message: "Wait a second while we prepare your image.")
//            self.present(self.pop, animated: true, completion: {
//                
//            })
//
//            singleton.didTakePic = false
//    
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                self.pop.dismiss()
//            })
//        }
    }
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
        background.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.addSubview(background)
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        vev.layer.cornerRadius = 0
        vev.layer.masksToBounds = true
        vev.frame = view.frame
        vev.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      //  background.addSubview(vev)
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
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("original")
            print(img.size)
            background.image = img
            singleton.imagePicked = img
            
        } else {
            print("not an image")
        }
        self.dismiss(animated: true, completion: {
            self.singleton.didTakePic = true
            self.appDelegate.goToMenuController()
           
        })
    }
    


}
