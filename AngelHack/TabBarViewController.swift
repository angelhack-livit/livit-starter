//
//  navigationControllerHandler.swift
//  AngelHack
//
//  Created by Jamal Rasool on 7/8/18.
//  Copyright © 2018 Jamal Rasool. All rights reserved.
//

import Foundation
import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import AWSUserPoolsSignIn
import AWSPinpoint
import Kingfisher
import BWWalkthrough

class tabControllerHandler: UITabBarController, UITabBarControllerDelegate, BWWalkthroughViewControllerDelegate {
    
    var needWalkthrough = Bool()
    var walkthrough:BWWalkthroughViewController!
    
    /**
     Handles calling the tutorial view if the application has been launched for the first time
     Handles the AWS login service
     Handles the navigationbar , and also tab bar view properties
     Handles Analytics
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        userHasOpenedBefore()
        loginHandler()
        setupStylization()
        logEvent()
        
    }
    
    /**
     self.loadTutorialView()
     Checks to see if the user needs the walkthrough or not and proceeds to launch those views instead
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needWalkthrough {
            self.loadTutorialView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    /**
     fileprivate func userHasOpenedBefore()
     Checks to see if the user is truly opened app for first time or not, in the case
     that the user has not already opened up app, it will add a new key into the devices
     storage that allows the program to know if its been opened or not
     */
    fileprivate func userHasOpenedBefore() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            needWalkthrough = false
        }
        else {
            print("First launch, setting NSUserDefault.")
            needWalkthrough = true
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarItem.tag == 1 {
            guard UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "Main") is HomePageViewController else {
                print("The Program Could not perform said action due to an unknown error")
                return
            }
        }
        
        if tabBarItem.tag == 2 {
            guard UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "Main") is SecondaryViewController else {
                print("The Program Could not perform said action due to an unknown error")
                return
            }
        }
        
        print("Selected view controller")
    }
    
    /**
     Amazon Sign-Out
     Function Designed to logout the user and present the login screen imedieatly after
     */
    
    @objc func handleLogOut(_ sender: UIButton) {
        AWSSignInManager.sharedInstance().logout { (result: Any?, error: Error?) in
            self.loginHandler()
            print("Sign-out Succesfful")
        }
        
    }
    
    /**
     Handles Transitions
     Function Designed to allow the view controllers to go from in between the amazon UI container, without causing breakage
     */
    
    fileprivate func handleNewController() {
        guard UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "Main") is HomePageViewController else {
            print("The Program Could not perform said action due to an unknown error")
            return
        }
    }
    
    /**
     Navigation Bar
     Function designed to set the two icons in the top menu bar, the right button for test case purposes will allow the user to logout using the
     handleLogOut selector
     */
    
    fileprivate func setupStylization() {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.handleLogOut(_:)))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
        self.tabBar.backgroundColor =  UIColorFromHex(rgbValue: 0x3498db, alpha: 1)
        view.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f1, alpha: 1)
        
        
    }
    
    
    /**
     Amazon login UI
     Function Designed to prompt the user for the login credential or the infomrmation relating to creating a new account
     or forgeting password steps, also allows us to modify the certain conditions within the layout.
     */
    
    fileprivate func loginHandler() {
        
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f1, alpha: 1) // Sets to the hex color
        config.font = UIFont (name: "Avenir", size: 12)
        config.isBackgroundColorFullScreen = true
        config.canCancel = false
        config.logoImage = #imageLiteral(resourceName: "paintLogo")
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController
                .presentViewController(with: self.navigationController!,
                                       configuration: config,
                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                                        if error != nil {
                                            print("Error occurred: \(String(describing: error))")
                                        } else {
                                            // Sign in successful.
                                        }
                })
        }
        
    }
    
    /**
     fileprivate func loadTutorialView()
     Handles the tutorial logic, this would be the place to add any new view controllers
     by essentially copying the same code, and modifying the identifer to pagen
     and adding said view controller, also within fucntion after walkthrough is completed
     it will set the tag to also being false.
     
     */
    fileprivate func loadTutorialView() {
    let storyb = UIStoryboard(name: "container", bundle: nil)
    let walkthrough = storyb.instantiateViewController(withIdentifier: "Master-Tutorial") as! BWWalkthroughViewController
    let page_one = storyb.instantiateViewController(withIdentifier: "page1") as UIViewController
    let page_two = storyb.instantiateViewController(withIdentifier: "page2") as UIViewController
    let page_three = storyb.instantiateViewController(withIdentifier: "page3") as UIViewController
    
    // Attach the pages to the master
    walkthrough.delegate = self
    walkthrough.add(viewController:page_one)
    walkthrough.add(viewController:page_two)
    walkthrough.add(viewController:page_three)
    
    self.present(walkthrough, animated: true) {
    ()->() in
    self.needWalkthrough = false
    }
    
    }
    
    
    /**
     Amazon analytics
     Function Designed to record to the database each time the user opens teh application
     */
    
    private func logEvent() {
        let tempAnalyticsClient = AWSPinpoint(configuration: AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: nil)).analyticsClient
        
        let special_event = tempAnalyticsClient.createEvent(withEventType: "HitNewGoal")
        special_event.addAttribute("DemoAttributeValue1", forKey: "DemoAttribute1")
        special_event.addAttribute("DemoAttributeValue2", forKey: "DemoAttribute2")
        special_event.addMetric(NSNumber.init(value: arc4random() % 65535), forKey: "HitNewGoal")
        tempAnalyticsClient.record(special_event)
        tempAnalyticsClient.submitEvents()
    }
}

/**
 tabControllerHandler
 Will allow the program to know when it will bring up the close button, once it reaches the final pages of the tutorial
 */

extension tabControllerHandler {
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if (self.walkthrough.numberOfPages - 1) == pageNumber{
            self.walkthrough.closeButton?.isHidden = false
        }else{
            self.walkthrough.closeButton?.isHidden = true
        }
    }
}




