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
    
    // Logout and dismiss MapViewController back to LoginViewController.
    @IBAction func logout(sender: UIBarButtonItem) {

        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
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
            self.dismissViewControllerAnimated(true, completion: nil)
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
            
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotations(studentAnnotationArray)
            })
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
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

