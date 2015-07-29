//
//  CollectionViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 7/24/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit

let reuseIdentifier = "CollectionCell"

class CollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    @IBOutlet weak var post: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView!.delegate = self
        self.navigationItem.rightBarButtonItems = [refresh, post]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  Get a new batch of data.
    func refreshData(){
        
        if Model.sharedInstance.batchNumber < Model.sharedInstance.highestBatchNumberAllowed{
       
            let client = Client()
            client.getStudentLocations(Model.sharedInstance.batchSize, skip: Model.sharedInstance.batchNumber * Model.sharedInstance.batchSize) {success, errorString in
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView!.reloadData()
                })
            }
            
            Model.sharedInstance.batchNumber++
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return the number of items in the section.
        return Model.sharedInstance.students.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionCell

        if indexPath.row % Model.sharedInstance.batchSize == Int(Model.sharedInstance.batchSize/2){
            
            self.refreshData()
        }
        
        // Configure the cell
        let currentElement = Model.sharedInstance.students[indexPath.row]
        let first = currentElement.firstName
        let last = currentElement.lastName
        let fullName = "\(indexPath.row) \(first) \(last)"
        let url = currentElement.mediaURL
        cell.nameLabel?.text = fullName
        cell.urlLabel?.text = url
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let collectionCell = collectionView.cellForItemAtIndexPath(indexPath) {
            let cell = collectionCell as! CollectionCell
            UIApplication.sharedApplication().openURL(NSURL(string: cell.urlLabel!.text!)!)
        }
    }
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath, indexPath: NSIndexPath) {
//        
//        if let collectionCell = collectionView.cellForItemAtIndexPath(indexPath){
//            
//            let text = collectionCell.urlLabel?.text
//            UIApplication.sharedApplication().openURL(NSURL(string: collectionCell.urlLabel!.text!)!)
//        }
//    }
}