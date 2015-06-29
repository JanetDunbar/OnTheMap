//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var refresh: UIBarButtonItem!
    @IBOutlet var post: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    var students = Model.sharedInstance.students

        /*
    protocol MKAnnotation: NSObject{
        var coordinate: CLLocationCoordinate2D{get}
        var title: String! {get}
        var subtitle: String! {get}
        
    }*/
    
    //TODO:  Finish!!!!!
    @IBAction func logout(sender: UIBarButtonItem) {
        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
//        request.HTTPMethod = "DELETE"
//        
//        //request.addValue("application/json", forHTTPHeaderField: "Accept")
//        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        var xsrfCookie: NSHTTPCookie? = nil
//        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
//            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//        }
//        ￼￼￼￼￼￼￼￼￼￼￼￼￼
//        if let xsrfCookie = xsrfCookie {
//            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
//        }
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { // Handle error...
//                println(error)
//                return
//            }
//            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
//            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
//        }
//        task.resume()
        
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
        }
        task.resume()
    }
    
    func makeStudentAnnotationFromStudentInformation(currentIndex:Int)-> StudentAnnotation{
        
        //Pin is showing, and map now centered on pin.
        var studentAnnotation: StudentAnnotation
        let currentStudent = students[currentIndex]
        let annotationLocation = CLLocationCoordinate2D(latitude: currentStudent.latitude, longitude: students[currentIndex].longitude)
        println(annotationLocation)
        let fullName = students[currentIndex].firstName + " " + currentStudent.lastName
        println("fullName = \(fullName)")
        let url = currentStudent.mediaURL
        
        var span = MKCoordinateSpanMake(100, 100)
        var region = MKCoordinateRegion(center: annotationLocation, span: span)
        
        mapView.setRegion(region, animated: true)
        
        studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: fullName, subtitle: url)
        return studentAnnotation
    
    }
  
    

    
    //untested - may need to change MKPinAnnotationView to MKAnnotationView?
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        var studentAnnotationArray = [AnyObject]()
        
        for (currentIndex,student) in enumerate(students){
        var studentAnnotation: AnyObject! = makeStudentAnnotationFromStudentInformation(currentIndex) as AnyObject
        
        println("studentAnnotation = \(studentAnnotation) in viewDidLoad")
        
        studentAnnotationArray.append(studentAnnotation)
        }
       
        mapView.addAnnotations(studentAnnotationArray)
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

