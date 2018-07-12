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
import AWSCore
import AWSS3

/**
 PREFACE:
 Frameworks being used
 1. AWS ✅ (Handle Login / Backend)
 2. BWWalkthrough ✅ (Handle walkthrough)
 3. Lightbox ✅ (Handle Images Being Loaded)
 4. MapViewPlus ✅ (Handle Maps)
 5. Kingfisher ✅ (Handle Media Queries)
 
 TODO:
 1. implement tableview class so that infomration could be queried fast [Use fonts]
 2. Possibly look into either IBM chat bot, or using Amazon Chatbot
 3. Add a mapview and have it possibly query data based upon something.
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
    
    fileprivate func uploadData() {
        
        let data: Data = Data() // Data to be uploaded
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: "YourBucket",
                                   key: "YourFileName",
                                   contentType: "text/plain",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                    }
                                    return nil;
        }
    }
    
    fileprivate func downloadData() {
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            // Do something e.g. Update a progress bar.
        })
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed downloads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(
            fromBucket: "YourBucket",
            key: "YourFileName",
            expression: expression,
            completionHandler: completionHandler
            ).continueWith {
                (task) -> AnyObject? in if let error = task.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                if let _ = task.result {
                    // Do something with downloadTask.
                    
                }
                return nil;
        }
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

/**
 TableViewController to handle the user posts that they post within the application
 
 
*/

class TableViewQueryController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    
}


