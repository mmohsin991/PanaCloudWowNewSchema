//
//  PreferencesVC.swift
//  AttendanceSystem
//
//  Created by Mohsin on 02/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit


class PreferencesVC: WowUIViewController, UISplitViewControllerDelegate {

    
    @IBOutlet weak var imgBackground: UIImageView!

    @IBOutlet weak var swtBackgroundColor: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Preferences"
        
//        self.imgBackground.image = backgroundImage
        
        
        // set the current theme switch status
//        if currentTheme == "Background2" {
//            self.swtBackgroundColor.setOn(true, animated: true)
//        }
//        else if currentTheme == "Background1" {
//            self.swtBackgroundColor.setOn(false, animated: true)
//        }
//        
        // enable the delegate,s functionality
        self.splitViewController?.delegate = self
        // hide the primary CV at startup
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
        
        // Assign the displayModeButtonItem to the vc navigation bar
        self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        self.navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
       // self.imgBackground.image = backgroundImage
        
    }
    
    
    @IBAction func colorSwitch(sender: UISwitch) {
        if sender.on{
            backgroundImage = UIImage(named: "Background2")
            currentTheme = "Background2"
            
            self.viewDidLoad()
            
        }
        else if !sender.on {
            backgroundImage = UIImage(named: "Background1")            
            currentTheme = "Background1"

            self.viewDidLoad()

            
            println(backgroundImage.description)

        }
    }
    
    
    // this func is hide the primary VC
    func targetDisplayModeForActionInSplitViewController(svc: UISplitViewController) -> UISplitViewControllerDisplayMode {
        return UISplitViewControllerDisplayMode.PrimaryOverlay
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rightMenu(sender: AnyObject) {
        delegate?.toggleRightPanel!()
    }
    

}
