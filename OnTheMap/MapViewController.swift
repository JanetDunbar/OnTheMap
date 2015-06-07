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
//        var annotation: StudentAnnotation
//        var student = students[0]
//        
//        annotation.title = student.firstName + "" +
//            student.lastName
//            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotationLocation = CLLocationCoordinate2D(latitude: -25.4283563, longitude: -49.2732515)
        
        //let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        // Do any additional setup after loading the view, typically from a nib.
        let studentAnnotation = StudentAnnotation(title: "Thiago Ricieri", coordinate: annotationLocation)
        mapView.addAnnotation(studentAnnotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

