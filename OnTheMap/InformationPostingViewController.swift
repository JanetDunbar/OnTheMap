//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import MapKit
import Foundation


class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var whereAreYouStudying: UILabel!
    @IBOutlet weak var findOnTheMap: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enterALink: UILabel!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    var newLatitude = 0.0
    var newLongitude = 0.0
    //var mediaUrl = ""
    var mapString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        address.delegate = self
        url.delegate = self
        mapView.delegate = self
        activityIndicatorView.hidesWhenStopped = true
        initialState()
        
    }
    
    func initialState(){
        address.hidden = false
        whereAreYouStudying.hidden = false
        findOnTheMap.hidden = false
        
        mapView.hidden = true
        enterALink.hidden = true
        url.hidden = true
        submit.hidden = true
    }
    
    func secondState(){
        address.hidden = true
        whereAreYouStudying.hidden = true
        findOnTheMap.hidden = true
        
        mapView.hidden = false
        enterALink.hidden = false
        url.hidden = false
        submit.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        //let address = "350 5th Avenue New York, NY"
        println(address)
        mapString = address.text
        
        activityIndicatorView.startAnimating()
        forwardGeocode(mapString)
        
        let secondsFromNow = 1.0
        dispatch_after(dispatch_time (DISPATCH_TIME_NOW, Int64(secondsFromNow * Double(NSEC_PER_SEC))), dispatch_get_main_queue()){
            self.activityIndicatorView.stopAnimating()
        }
    }

    func forwardGeocode(mapString: String!){
        let geoCoder = CLGeocoder()
        
        
        geoCoder.geocodeAddressString(mapString,
        completionHandler:
        {(placemarks: [AnyObject]!, error: NSError!) in
        
        if error != nil {
            //TODO:  Display an alert if geocoder fails
            println("Geocode failed with error: \(error.localizedDescription)")
        }
        
        if placemarks.count > 0 {
            let placemark = placemarks[0] as! CLPlacemark
            let location = placemark.location
            println("\(location.coordinate.latitude) \(location.coordinate.longitude)")
            self.newLatitude = location.coordinate.latitude
            self.newLongitude = location.coordinate.longitude
            let annotationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            println(annotationLocation)
            
            let url = ""
                
            var span = MKCoordinateSpanMake(100, 100)
            var region = MKCoordinateRegion(center: annotationLocation, span: span)
            
            self.mapView.setRegion(region, animated: true)
            
            let studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: "", subtitle: "")
            //studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: fullName, subtitle: url)
            //return annotation
                
            self.secondState()
            self.mapView.addAnnotation(studentAnnotation)

            }
        })
    }
    
    func reformatString(string: String)->String{
        
        let aString = "\"\(string)\""
        return aString
    }

    @IBAction func submitNewLocationAndUrl(sender: UIButton) {
        
        println("mapString = \(mapString)")
        println("mediaUrl = \(url.text)")
        println("newLatitude = \(newLatitude)")
        println("newLongitude = \(newLongitude)")
        
        // Reformat strings.
        let reformattedMapString = reformatString(mapString)
        let reformattedUrl = reformatString(url.text)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody = "{\"uniqueKey\": \"jmd@ccrma.stanford.edu\", \"firstName\": \"Janet\", \"lastName\": \"Dunbar\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url.text)\", \"latitude\": newLatitude, \"longitude\": newLongitude}".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody = "{\"uniqueKey\": \"jmd@ccrma.stanford.edu\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url.text)\", \"latitude\": newLatitude, \"longitude\": newLongitude}".dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Janet\", \"lastName\": \"Dunbar\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        println("request.HTTPBody = \(request.HTTPBody)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                println("Error, task, InformationPostingViewController")
                return
            }
            let studentLocationString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            println("studentLocationString = \(studentLocationString)")
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
