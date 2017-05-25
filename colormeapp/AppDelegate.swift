//
//  AppDelegate.swift
//  colormeapp
//
//  Created by Max Nelson on 5/21/17.
//  Copyright © 2017 Maxnelson. All rights reserved.
//

import UIKit
import CoreData
import Font_Awesome_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var singleton:ColorMeSingleton = ColorMeSingleton()
    
    var window: UIWindow?
    var navigationController:UINavigationController!
    var viewsToNavigateTo:[UIViewController]  = []
    
    struct navType: OptionSet {
        //bitmask value
        let rawValue:Int

        static let back = navType(rawValue: 1)
        static let forward = navType(rawValue: 2)
        static let bars = navType(rawValue: 4)
        static let logo = navType(rawValue: 8)
    }

    func makeTitle(titleText:String) -> UIButton {
        let navTitle = UIButton(type: .custom)
        navTitle.setTitle(titleText, for: .normal)
        navTitle.titleLabel?.font = UIFont.MNExoFontTwentySemiBold
        navTitle.setTitleColor(UIColor.white, for: .normal)
        return navTitle
    }
    
    func makeNavItem(tag:Int? = 0, type:navType, alignment:UIControlContentHorizontalAlignment) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 0)
        btn.contentHorizontalAlignment = alignment
        if tag != nil {btn.tag = tag!}
        switch type {
        case navType.forward:
            btn.setFAIcon(icon: FAType.FAArrowRight, iconSize: 30, forState: UIControlState.normal)
            btn.addTarget(self, action: #selector(self.navigateToView), for: .touchUpInside)
        case navType.back:
            btn.setFAIcon(icon: FAType.FAArrowLeft, iconSize: 30, forState: UIControlState.normal)
            btn.addTarget(navigationController, action: #selector(self.navigationController.popViewController(animated:)), for: .touchUpInside)
        case navType.logo:
            let loView = UIImageView(image: #imageLiteral(resourceName: "photo-camera"))
            loView.image = loView.image?.withRenderingMode(.alwaysTemplate)
            loView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            loView.contentMode = .scaleAspectFit
            loView.tintColor = .white
            loView.addGestureRecognizer(UITapGestureRecognizer(target: navigationController, action: #selector(self.navigationController.popViewController(animated:))))
            let navItem = UIBarButtonItem(customView: loView)
            return navItem
        default:
            break
        }
        
        let navItem = UIBarButtonItem(customView: btn)
        return navItem
    }
    
    func navigateToView(sender:UIButton) {
        let nextView = viewsToNavigateTo[sender.tag]
        navigationController.pushViewController(nextView, animated: true)
    }
    
    func goToEditController() {
        navigationController.pushViewController(editVC, animated: true)
    }
    func goToMenuController() {
        navigationController.pushViewController(menuVC, animated: true)
    }
    
    var cameraVC:CameraController!
    var menuVC:MenuController!
    var editVC:EditController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        for family: String in UIFont.familyNames
        {
            if family.contains("Exo") {
                print("\(family)")
                for names: String in UIFont.fontNames(forFamilyName: family)
                {
                    print("== \(names)")
                }
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController()
        
        cameraVC = CameraController()
        cameraVC.navigationItem.titleView = makeTitle(titleText: "PICTURE ME")
        cameraVC.navigationItem.leftBarButtonItem = makeNavItem(type: .logo, alignment: .left)
        cameraVC.navigationItem.rightBarButtonItem = makeNavItem(tag: 0, type: .forward, alignment: .right)
        
        menuVC = MenuController()
        menuVC.navigationItem.titleView = makeTitle(titleText: "COLOR ME")
        menuVC.navigationItem.leftBarButtonItem = makeNavItem(type: .logo, alignment: .left)
        //menuVC.navigationItem.rightBarButtonItem = makeNavItem(tag: 1, type: .forward, alignment: .right)
        
        editVC = EditController()
        editVC.navigationItem.titleView = makeTitle(titleText: "EDIT ME")
        editVC.navigationItem.leftBarButtonItem = makeNavItem(type: .back, alignment: .left)
        editVC.navigationItem.rightBarButtonItem = makeNavItem(tag: 0, type: .logo, alignment: .right)
        
        viewsToNavigateTo = [menuVC, editVC]
        
        navigationController.edgesForExtendedLayout = .left
        navigationController.viewControllers = [cameraVC, menuVC]
        
        UINavigationBar.appearance().barTintColor = UIColor.MNLightBlue
        UINavigationBar.appearance().tintColor = UIColor.white
        
        self.window!.rootViewController = navigationController
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()


        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "colormeapp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

