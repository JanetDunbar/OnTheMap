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
}
