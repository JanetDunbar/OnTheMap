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
    
    // Make soft singleton
    class var sharedInstance: Model{
        
        struct Statics{
            
            static var instance = Model()
            
        }
        
        return Statics.instance

    }
    
}
