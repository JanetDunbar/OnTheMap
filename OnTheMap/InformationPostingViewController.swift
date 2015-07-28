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

    @IBOutlet weak var browseToTheLink: UIButton!
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
    var mapString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        browseToTheLink.hidden = true
    }
    
    func secondState(){
        address.hidden = true
        whereAreYouStudying.hidden = true
        findOnTheMap.hidden = true
        
        mapView.hidden = false
        enterALink.hidden = false
        url.hidden = false
        submit.hidden = false
        browseToTheLink.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func findOnTheMap(sender: UIButton) {
        
        // Highlight label as additional indication of geocoding;
        // whereAreYouStudying label turns orange.
        self.whereAreYouStudying.highlighted = true
        mapString = address.text
        
        activityIndicatorView.startAnimating()
        
        forwardGeocode(mapString)
        
        let secondsFromNow = 1.0
        dispatch_after(dispatch_time (DISPATCH_TIME_NOW, Int64(secondsFromNow * Double(NSEC_PER_SEC))), dispatch_get_main_queue()){
           
            // Stop activityIndicatorView from spinning
            self.activityIndicatorView.stopAnimating()
        }
    }

    func forwardGeocode(mapString: String!){
        let geoCoder = CLGeocoder()
        
        
        geoCoder.geocodeAddressString(mapString,
        completionHandler:
        {(placemarks: [AnyObject]!, error: NSError!) in
        
        if error != nil {
            // Display an alert if geocoder fails
            println("Geocode failed with error: \(error.localizedDescription)")
            self.displayAlert("Please enter your location again.")
            return
        }
        
        if placemarks.count > 0 {
            let placemark = placemarks[0] as! CLPlacemark
            let location = placemark.location
            println("\(location.coordinate.latitude) \(location.coordinate.longitude)")
            self.newLatitude = location.coordinate.latitude
            self.newLongitude = location.coordinate.longitude
            let annotationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let url = ""
            var span = MKCoordinateSpanMake(100, 100)
            var region = MKCoordinateRegion(center: annotationLocation, span: span)
            
            self.mapView.setRegion(region, animated: true)
            
            let studentAnnotation = StudentAnnotation(coordinate: annotationLocation, title: "", subtitle: "")
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
        
        // Post student location and ul; mapString, newLatitude and newLongitude post correctly.
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Janet\", \"lastName\": \"Dunbar\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url.text)\",\"latitude\": \(newLatitude), \"longitude\": \(newLongitude)}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                println("Error, task, InformationPostingViewController")
                return
            }
            let studentLocationString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String

            Model.sharedInstance.resetModel() // Force a refresh
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        task.resume()
    }
    
    func displayAlert(errorMessage: String){
        
        let alertController = UIAlertController(title: "Geocoding Error", message: errorMessage, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "GoToWebVC" {
            let vc = segue.destinationViewController as! WebVC
            // set up the vc to run here
            //vc.myWebView.loadHTMLString(url.text, baseURL: nil)
            vc.urlText = url.text
        }
    }
}
