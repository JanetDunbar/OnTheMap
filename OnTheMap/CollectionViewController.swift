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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView!.delegate = self
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
        
        println("In refreshData in TableViewController")
        
        if Model.sharedInstance.batchNumber >= Model.sharedInstance.highestBatchNumberAllowed{
            println("batchNumber greater than \(Model.sharedInstance.highestBatchNumberAllowed)")
        }
        else {
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
}