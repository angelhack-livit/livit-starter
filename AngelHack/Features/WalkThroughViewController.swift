//
//  WalkThroughViewController.swift
//  AngelHack
//
//  Created by Jamal Rasool on 7/9/18.
//  Copyright © 2018 Jamal Rasool. All rights reserved.
//

import Foundation
import UIKit
import BWWalkthrough

class tutorialController: BWWalkthroughViewController, BWWalkthroughViewControllerDelegate {
    
    @IBOutlet weak var skipTutorial: UIButton!
    @IBOutlet weak var pageViewConditional: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTutorialView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
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
        
    }
}
