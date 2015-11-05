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
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    
    init (coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}
