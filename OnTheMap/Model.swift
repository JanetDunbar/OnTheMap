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

    // Batching data
    let batchSize = 100
    // batchNumber is 0 based (0-9) to limit total number of student locations to 1000
    let highestBatchNumberAllowed = 9
    var batchNumber = 0
    
    func resetModel() {
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
