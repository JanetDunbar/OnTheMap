//
//  Model.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/3/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import Foundation

class Model{
    
    var students = [StudentInformation]()

    // batchSize is number of student locations to get from server per batch
    let batchSize = 100
    // batchNumber is 0 based (0-9) to limit total number of student locations to 1000, now limited by reduced size of database
    let highestBatchNumberAllowed = 10
    var batchNumber = 0
    
    func resetModel() {
        print("**** RESET model!!! ")
        students = [StudentInformation]()
        batchNumber = 0
    }
    
    // Make soft singleton
    class var sharedInstance: Model{
        
        struct Statics{
            
            static var instance = Model()
            
        }
        
        return Statics.instance

    }
}
