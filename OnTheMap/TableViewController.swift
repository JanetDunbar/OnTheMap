//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/18/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    @IBOutlet weak var post: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        self.navigationItem.rightBarButtonItems = [refresh, post]
    }
    
    // Setup data model and update data.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    func displayAlert(errorMessage: String){
        
        let alertController = UIAlertController(title: "Problem while refreshing.", message: errorMessage, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Get a batch of data.
    func refreshData(){

        if Model.sharedInstance.batchNumber < Model.sharedInstance.highestBatchNumberAllowed{
            let client = Client()
            client.getStudentLocations(Model.sharedInstance.batchSize, skip: Model.sharedInstance.batchNumber * Model.sharedInstance.batchSize) {success, errorString in
                
                if success{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                } else {
                    self.displayAlert(errorString)
                    
                }
            }
            
            Model.sharedInstance.batchNumber++
        }
    }
    
    // Create cell; add its data.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let count = Model.sharedInstance.students.count
        if indexPath.row % Model.sharedInstance.batchSize == Int(Model.sharedInstance.batchSize/2){
            
            self.refreshData()
        }
        
        let currentElement = Model.sharedInstance.students[indexPath.row]
        let separator  = " "
        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row) \(currentElement.firstName) \(currentElement.lastName)"
        cell.detailTextLabel?.text = currentElement.mediaURL
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        return Model.sharedInstance.students.count
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let tableCell = tableView.cellForRowAtIndexPath(indexPath){
            
            let text = tableCell.detailTextLabel?.text
            UIApplication.sharedApplication().openURL(NSURL(string: tableCell.detailTextLabel!.text!)!)
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        // Prepare model to receive new batch of data.
        Model.sharedInstance.resetModel()
        refreshData()
    }
    
    // Logout from Udacity; logout from Facebook occurs in LoginViewController, after TableViewController has been dismissed.
   
    @IBAction func logout(sender: UIBarButtonItem) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error…
                println(error)
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        task.resume()
    }
}
