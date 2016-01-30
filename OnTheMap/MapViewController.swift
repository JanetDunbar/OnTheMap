//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//
//  On initial display, the map shows only 100 annotations.
//  However, table and collection load the data model with 9 more batches
//  of 100 annotations.  When the user revisits the map view, more than 100
//  pins appear.

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
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                
                print(error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
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
        let fullName = "\(currentIndex) \(students[currentIndex].firstName) \(currentStudent.lastName)"
        let url = currentStudent.mediaURL
        
        let span = MKCoordinateSpanMake(100, 100)
        var region = MKCoordinateRegion(center: annotationLocation, span: span)
                
        studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: fullName, subtitle: url)
        return studentAnnotation
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        if let annotation = annotation as? StudentAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let str = view.annotation!.subtitle
        let url = NSURL(string: str!!)
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up mapViewDelegate.
        mapView.delegate = self
        self.navigationItem.rightBarButtonItems = [refresh, post]
       
    }
    
    func displayAlert(errorMessage: String){
        
        let alertController = UIAlertController(title: "Problem while refreshing.", message: errorMessage, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Get a new batch of data.
    func refreshData(){

        let client = Client()
        client.getStudentLocations() {success, errorString in
            
            if success{
            
                var studentAnnotationArray = [AnyObject]()
                
                for (currentIndex,student) in Model.sharedInstance.students.enumerate(){
                    var studentAnnotation: AnyObject! = self.makeStudentAnnotationFromStudentInformation(currentIndex) as AnyObject
                    
                    studentAnnotationArray.append(studentAnnotation)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.addAnnotations(studentAnnotationArray as! [MKAnnotation])
                })

                
            } else {
                self.displayAlert(errorString)
                
            }
        }
    }
    
     // Call refreshData when user hits refresh button.
    @IBAction func refresh(sender: UIBarButtonItem) {
        
        Model.sharedInstance.resetModel()
        self.refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        dispatch_async(dispatch_get_main_queue(), {
            self.refreshData()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        // Display annotations in an appropriate region
        // according to Apple documentation
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

