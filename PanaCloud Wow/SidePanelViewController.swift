//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func VClSelected(#VC: WowUIViewController)
}


protocol LogoutDelegate {
    func Logout()
}



class SidePanelViewController: UITableViewController {

    var tempData = ["Home","Attendance","Preferences","Log Out"]
    var imgArray = ["home","attendance","setting","logout"]

    var delegate: SidePanelViewControllerDelegate?
    
    var logoutDelegate: LogoutDelegate?

  struct TableView {
    struct CellIdentifiers {
      static let AnimalCell = "AnimalCell"
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        
       // self.view.frame.origin = CGPoint(x: 200 , y: 0)
       
        
        // disabel the
        self.tableView.bounces = false
        
    }

    override func viewWillAppear(animated: Bool) {
        //self.tableView.backgroundView = backgroundImageView
        self.tableView.backgroundColor = colorLBlue
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            delegate?.VClSelected(VC: UIStoryboard.homeVC()!)
        }
            
        else if indexPath.row == 1 {
        }
            
        else if indexPath.row == 2 {
            delegate?.VClSelected(VC: UIStoryboard.preferencesVC()!)
        }
        else if indexPath.row == 3 {
            logoutDelegate?.Logout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tempData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = self.tempData[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(18)
    
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        
        cell.imageView?.image = UIImage(named: self.imgArray[indexPath.row])
        //cell.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        
        // Configure the cell selection color
        let backgroundColorView = UIView()
        backgroundColorView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        cell.selectedBackgroundView = backgroundColorView
        
        // for LogOut cell text color
        if indexPath.row == 3 {
            cell.textLabel?.textColor = UIColor.lightTextColor()
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "MENU"
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
            return 65.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
}

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("menuVCID") as? SidePanelViewController
    }
    
    class func homeVC() -> HomeVC? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("homeVCID") as? HomeVC
    }
    
//    class func teamVC() -> TeamVC? {
//        return mainStoryboard().instantiateViewControllerWithIdentifier("teamVCID") as? TeamVC
//    }
    
    class func preferencesVC() -> PreferencesVC? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("preferencesVCID") as? PreferencesVC
    }

//    class func loginVC() -> LoginVC? {
//        return mainStoryboard().instantiateViewControllerWithIdentifier("loginVCID") as? LoginVC
//    }
}

