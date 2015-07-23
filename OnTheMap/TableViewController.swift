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
    
    // TODO:  Check if these button outlets need to be weak
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    @IBOutlet weak var post: UIBarButtonItem!
    
    let mapViewController = MapViewController()
    
//    var students = Model.sharedInstance.students
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.rowHeight = 100
        self.navigationItem.rightBarButtonItems = [refresh, post]
        
    }
    
    // Setup data model and update data.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        dispatch_async(dispatch_get_main_queue(), {
//            self.refreshData()
//        })
        self.refreshData()
        
        //self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(true)
//        
//        self.tableView.reloadData()
//    }
    
    func refreshData(){
        
        println("In refreshData in TableViewController")
        //let limit = 10
        //let skip = 10
        
        let client = Client()
        client.getStudentLocations(100, skip: 0) {success, errorString in
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
            //self.tableView.reloadData()
//            var studentAnnotationArray = [AnyObject]()
//            
//            println("Model.sharedInstance.students.count = \(Model.sharedInstance.students.count)")
//            
//            for (currentIndex,student) in enumerate(Model.sharedInstance.students){
//                var studentAnnotation: AnyObject! = self.makeStudentAnnotationFromStudentInformation(currentIndex) as AnyObject
//                
//                println("studentAnnotation = \(studentAnnotation) in refreshData")
//                
//                studentAnnotationArray.append(studentAnnotation)
//            }
            
            //self.mapView.addAnnotations(studentAnnotationArray)
        }
    }

    
    // Create cell; add its data.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let currentElement = Model.sharedInstance.students[indexPath.row]
        let separator  = " "
        // Configure the cell...
        cell.textLabel?.text = currentElement.firstName + separator + currentElement.lastName
        cell.detailTextLabel?.text = currentElement.mediaURL
        println(currentElement.firstName + separator + currentElement.lastName)
        //cell.imageView?.image = currentElement.memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        
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
//        dispatch_async(dispatch_get_main_queue(), {
//            self.mapViewController.refreshData()
//        })
        
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
