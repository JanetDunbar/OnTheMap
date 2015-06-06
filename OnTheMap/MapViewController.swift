//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var pin: MKPinAnnotationView?
    //let studentArray = StudentInformation.StudentInformationFromResults()
    
    //func MakePinAnnotationFromStudentInformation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

