//
//  Student.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/6/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import Foundation
import MapKit

class StudentAnnotation: NSObject, MKAnnotation {
    
    var title: String
    var coordinate: CLLocationCoordinate2D
    
    init (title: String, coordinate: CLLocationCoordinate2D){
        
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}
