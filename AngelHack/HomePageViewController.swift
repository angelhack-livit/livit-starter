//
//  ViewController.swift
//  AngelHack
//
//  Created by Jamal Rasool on 7/2/18.
//  Copyright © 2018 Jamal Rasool. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore
import AWSPinpoint
import AWSAuthUI
import Kingfisher

class HomePageViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f1, alpha: 1)
        loginHandler()
        setupNavbar()
        hideKeyboard()
        logEvent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        guard let newViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "Main") as? navigationControllerHandler else {
            print("The Program Could not perform said action due to an unknown error")
            return
        }
        self.navigationController?.present(newViewController, animated: true, completion: nil)
        
    }
    
    /**
     Navigation Bar
     Function designed to set the two icons in the top menu bar, the right button for test case purposes will allow the user to logout using the
     handleLogOut selector
     */
    
    fileprivate func setupNavbar() {
        let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.handleLogOut(_:)))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
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
                                            self.handleNewController()
                                        }
                })
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
 Frameworks being used
 1. AWS ✅ (Handle Login / Backend)
 2. BWWalkthrough ✅ (Handle walkthrough)
 3. Lightbox ✅ (Handle Images Being Loaded)
 4. MapViewPlus ✅ (Handle Maps)
 5. Kingfisher ✅ (Handle Media Queries)
 6. 
 7. IBAnimatable???? ❌
 */
