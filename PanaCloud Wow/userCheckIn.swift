//
//  userCheckIn.swift
//  PanaCloud Wow
//
//  Created by Mohsin on 31/01/2015.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class userCheckIn: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnUpdate: UIButton!
    
    let teams = ["Pana Swift Team","Pana Wow Team","Swift TA Team","MCS Final"]
    let orgs = ["PanaCloud (Pvt) Ltd.","PanaCloud (Pvt) Ltd.","Sir syed University","Univrsity Of Karachi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnUpdate.layer.cornerRadius = 4.0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return teams.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        // toggle b/w check and uncheck
        if cell?.accessoryType != UITableViewCellAccessoryType.Checkmark {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = teams[indexPath.row]
        cell.detailTextLabel?.text = orgs[indexPath.row]
        
        cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        cell.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        cell.textLabel?.textColor = colorLBlue
        
        
        // for image to round shape
        //        cell.imageView?.layer.cornerRadius = 25
        //        cell.imageView?.layer.masksToBounds = true
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }


    @IBAction func update(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
