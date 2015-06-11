//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var students = Model.sharedInstance.students

        /*
    protocol MKAnnotation: NSObject{
        var coordinate: CLLocationCoordinate2D{get}
        var title: String! {get}
        var subtitle: String! {get}
        
    }*/
    
    
    func makePinAnnotationFromStudentInformation(){
        
    //Pin is showing, and map now centered on pin.
    let annotationLocation = CLLocationCoordinate2D(latitude: -students[0].latitude, longitude: students[0].longitude)
    println(annotationLocation)
    let fullName = students[0].firstName + " " + students[0].lastName
    println("fullName = \(fullName)")
    let url = students[0].mediaURL
    
    var span = MKCoordinateSpanMake(100, 100)
    var region = MKCoordinateRegion(center: annotationLocation, span: span)
    
    mapView.setRegion(region, animated: true)
    
    let studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: fullName, subtitle: url)
    mapView.addAnnotation(studentAnnotation)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePinAnnotationFromStudentInformation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

