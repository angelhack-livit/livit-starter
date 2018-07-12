//
//  ViewController.swift
//  AngelHack
//
//  Created by Jamal Rasool on 7/2/18.
//  Copyright © 2018 Jamal Rasool. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSPinpoint
import AWSAuthUI
import Kingfisher

/**
 PREFACE:
 Frameworks being used
 1. AWS ✅ (Handle Login / Backend)
 2. BWWalkthrough ✅ (Handle walkthrough)
 3. Lightbox ✅ (Handle Images Being Loaded)
 4. MapViewPlus ✅ (Handle Maps)
 5. Kingfisher ✅ (Handle Media Queries)
 */


/**
 HomePageViewController
 Will probably house the main tableview in which the user can scroll through the different possible activites
 or goals for the application.
 */

class HomePageViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("It works")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
}

/**
 SecondaryViewController
 Handles what ever possible third idea we will implement
*/
class SecondaryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}


