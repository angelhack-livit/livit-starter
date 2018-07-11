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

class navigationControllerHandler: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColorFromHex(rgbValue: 0xecf0f1, alpha: 1)
        let homeControl = HomePageViewController()
        
        show(homeControl, sender: Any?.self)
    }
    
}

