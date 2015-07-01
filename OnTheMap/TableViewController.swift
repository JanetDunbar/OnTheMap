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
    
//    var students = Model.sharedInstance.students
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        self.navigationItem.rightBarButtonItems = [refresh, post]
        
    }
    
    // Setup data model and update data.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.tableView.reloadData()
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
}
