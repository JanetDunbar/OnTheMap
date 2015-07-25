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
    
    // Newly added
    let batchSize = 100
    // NB: batchNumber is 0 based (0-9) to limit total number of student locations to 1000
    let highestBatchNumberAllowed = 9
    var batchNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView!.delegate = self
        //TODO:  For possible refresh and post buttons
        //self.navigationItem.rightBarButtonItems = [refresh, post]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // Newly added
        refreshData()

    }
    
    // Newly added
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Newly added
    func refreshData(){
        
        println("In refreshData in TableViewController")
        
        if batchNumber >= highestBatchNumberAllowed{
            println("batchNumber greater than \(highestBatchNumberAllowed)")
        }
        else {
            let client = Client()
            client.getStudentLocations(batchSize, skip: batchNumber * batchSize) {success, errorString in
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView!.reloadData()
                })
            }
            
            batchNumber++
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return the number of items in the section.
        println("inside numberofRowsInSection")
        println("Model.sharedInstance.students.count = \(Model.sharedInstance.students.count)")
        return Model.sharedInstance.students.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionCell
        // New code
        if indexPath.row % batchSize == Int(batchSize/2){
            
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
