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
    
    
//    func makePinAnnotationFromStudentInformation(student: StudentInformation){
//        
//        var annotation: StudentAnnotation = []
//        var student = students[0]
//        
//        student.title = student.firstName + "" +
//            student.lastName
//    
//            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pin is showing, but map not centered on pin.  Separate into its own function and call here.
        let annotationLocation = CLLocationCoordinate2D(latitude: -students[0].latitude, longitude: students[0].longitude)
        println(annotationLocation)
        let fullName = students[0].firstName + " " + students[0].lastName
        println("fullName = \(fullName)")
        
        var span = MKCoordinateSpanMake(100, 100)
        var region = MKCoordinateRegion(center: annotationLocation, span: span)
        
        mapView.setRegion(region, animated: true)

        let studentAnnotation = StudentAnnotation(title: fullName, coordinate: annotationLocation)
        mapView.addAnnotation(studentAnnotation)
        
        // Below code places pin on map but out of initial view.
        
//        let annotationLocation = CLLocationCoordinate2D(latitude: -25.4283563, longitude: -49.2732515)
//        let studentAnnotation = StudentAnnotation(title: "Thiago Ricieri", coordinate: annotationLocation)
//        mapView.addAnnotation(studentAnnotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

