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
    
    let batchSize = 100
    // NB: batchNumber is 0 based (0-9) to limit total number of student locations to 1000
    let highestBatchNumberAllowed = 9
    var batchNumber = 0

    
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
    
    func refreshData(){
        
        println("In refreshData in TableViewController")
        
        if batchNumber >= highestBatchNumberAllowed{
            println("batchNumber greater than \(highestBatchNumberAllowed)")
        }
        else {
            let client = Client()
            client.getStudentLocations(batchSize, skip: batchNumber * batchSize) {success, errorString in
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
            
            batchNumber++
        }
    }

    
    // Create cell; add its data.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let count = Model.sharedInstance.students.count
        if indexPath.row % batchSize == Int(batchSize/2){
            
            self.refreshData()
        }
        
        let currentElement = Model.sharedInstance.students[indexPath.row]
        let separator  = " "
        // Configure the cell...
        cell.textLabel?.text = "\(indexPath.row) \(currentElement.firstName) \(currentElement.lastName)"
        cell.detailTextLabel?.text = currentElement.mediaURL
        println(currentElement.firstName + separator + currentElement.lastName)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        println("inside numberofRowsInSection")
        println("Model.sharedInstance.students.count = \(Model.sharedInstance.students.count)")
        return Model.sharedInstance.students.count
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //UIApplication.sharedApplication().openURL(NSURL(string: view.annotation.subtitle!)!)
        if let tableCell = tableView.cellForRowAtIndexPath(indexPath){
            let text = tableCell.detailTextLabel?.text
            println(text)
            //UIApplication.sharedApplication().openURL(NSURL(string: tableCell!.detailTextLabel?.text))
            UIApplication.sharedApplication().openURL(NSURL(string: tableCell.detailTextLabel!.text!)!)
        }
    }
// Error message:  fatal error: unexpectedly found nil while unwrapping an Optional value
//??Need to add analogous refreshData func
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        println("TableViewController: In IBAction refresh")
        refreshData()
        
    }
    
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
            if error != nil { // Handle error…
                //
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
