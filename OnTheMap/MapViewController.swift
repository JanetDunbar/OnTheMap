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

    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var post: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    ///var students = Model.sharedInstance.students

        /*
    protocol MKAnnotation: NSObject{
        var coordinate: CLLocationCoordinate2D{get}
        var title: String! {get}
        var subtitle: String! {get}
        
    }*/
    
    //TODO:  Finish!!!!Doesn't appear to be logging out.  Shouldn't allow post.
    //Use println--Must take away optional.
    @IBAction func logout(sender: UIBarButtonItem) {

        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        
        //Still not logging out.  Still allows posting.
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")


        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                //
                println(error)
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }
    
    func makeStudentAnnotationFromStudentInformation(currentIndex:Int)-> StudentAnnotation{
        var students = Model.sharedInstance.students
        //Pin is showing, and map now centered on pin.
        var studentAnnotation: StudentAnnotation
        let currentStudent = students[currentIndex]
        let annotationLocation = CLLocationCoordinate2D(latitude: currentStudent.latitude, longitude: students[currentIndex].longitude)
        //println(annotationLocation)
        let fullName = students[currentIndex].firstName + " " + currentStudent.lastName
        //println("fullName = \(fullName)")
        let url = currentStudent.mediaURL
        
        var span = MKCoordinateSpanMake(100, 100)
        var region = MKCoordinateRegion(center: annotationLocation, span: span)
        
        //mapView.setRegion(region, animated: true)
        
        studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: fullName, subtitle: url)
        return studentAnnotation
    
    }
  
    

    
    // May need to change MKPinAnnotationView to MKAnnotationView?
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? StudentAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: view.annotation.subtitle!)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up mapViewDelegate.
        mapView.delegate = self
        self.navigationItem.rightBarButtonItems = [refresh, post]
       
    }
    
    func refreshData(){
        
        println("In refreshData in MapViewController")
        
        let client = Client()
        client.getStudentLocations() {success, errorString in
            var studentAnnotationArray = [AnyObject]()
            
            println("Model.sharedInstance.students.count = \(Model.sharedInstance.students.count)")
            
            for (currentIndex,student) in enumerate(Model.sharedInstance.students){
                var studentAnnotation: AnyObject! = self.makeStudentAnnotationFromStudentInformation(currentIndex) as AnyObject
                
                println("studentAnnotation = \(studentAnnotation) in refreshData")
                
                studentAnnotationArray.append(studentAnnotation)
            }
            
            self.mapView.addAnnotations(studentAnnotationArray)
        }
    }
    
     // Call refreshData asynchronously when user hits refresh button.
        @IBAction func refresh(sender: UIBarButtonItem) {
    
            println("In refresh")
            dispatch_async(dispatch_get_main_queue(), {
                self.refreshData()
            })
        }
    
    override func viewWillAppear(animated: Bool) {
        
        println("In viewWillAppear")

        super.viewWillAppear(true)
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.refreshData()
        })
        
        
//        let client = Client()
//        client.getStudentLocations(){
//            var studentAnnotationArray = [AnyObject]()
//            
//            println("Model.sharedInstance.students.count = \(Model.sharedInstance.students.count)")
//            
//            for (currentIndex,student) in enumerate(Model.sharedInstance.students){
//                var studentAnnotation: AnyObject! = self.makeStudentAnnotationFromStudentInformation(currentIndex) as AnyObject
//                
//                println("studentAnnotation = \(studentAnnotation) in viewWillAppear")
//                
//                studentAnnotationArray.append(studentAnnotation)
//            }
//        
//            self.mapView.addAnnotations(studentAnnotationArray)
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let secondsFromNow = 1.0
        //zoomMapViewToFitAnnotations(mapView, animated: true )
//        dispatch_after(dispatch_time (DISPATCH_TIME_NOW, Int64(secondsFromNow * Double(NSEC_PER_SEC))), dispatch_get_main_queue()){
//            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
//        }

        mapView.showAnnotations(mapView.annotations, animated: true)
        //mapView.camera.altitude *= 1.4;
        //self.reloadInputViews()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func zoomMapViewToFitAnnotations(mapView: MKMapView, animated: Bool) {
//        let MINIMUM_ZOOM_ARC = 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
//        let ANNOTATION_REGION_PAD_FACTOR = 1.15
//        //let ANNOTATION_REGION_PAD_FACTOR = 15.0
//        let MAX_DEGREES_ARC: CLLocationDegrees = 360
//        
//        var annotations = mapView.annotations
//        let count = mapView.annotations.count
//        if (count == 0) { return } //bail if no annotations
//        
//        //convert NSArray of id into an MKCoordinateRegion that can be used to set the map size
//        var points = [MKMapPoint]() //C array of MKMapPoint struct
//        for annotation in annotations {
//            let coordinate = (annotation as! MKAnnotation).coordinate
//            points.append(MKMapPointForCoordinate(coordinate))
//        }
//        
//        //create MKMapRect from array of MKMapPoint
//        let polygon = MKPolygon(points: UnsafeMutablePointer(points), count:count)
//        let mapRect = polygon.boundingMapRect
//        //convert MKCoordinateRegion from MKMapRect
//        var region = MKCoordinateRegionForMapRect(mapRect)
//        
//        //add padding so pins aren’t scrunched on the edges
//        region.span.latitudeDelta *= ANNOTATION_REGION_PAD_FACTOR
//        region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR
//        //but padding can’t be bigger than the world
//        if (region.span.latitudeDelta > MAX_DEGREES_ARC) { region.span.latitudeDelta = MAX_DEGREES_ARC }
//        if (region.span.longitudeDelta > MAX_DEGREES_ARC) { region.span.longitudeDelta = MAX_DEGREES_ARC }
//        
//        //and don’t zoom in stupid-close on small samples
//        if (region.span.latitudeDelta < MINIMUM_ZOOM_ARC) { region.span.latitudeDelta = MINIMUM_ZOOM_ARC }
//        if (region.span.longitudeDelta < MINIMUM_ZOOM_ARC) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC }
//        //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
//        if (count == 1) {
//            region.span.latitudeDelta = MINIMUM_ZOOM_ARC
//            region.span.longitudeDelta = MINIMUM_ZOOM_ARC
//        }
//        mapView.setRegion(region, animated: animated)
//    }


}

