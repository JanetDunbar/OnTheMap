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
        let mapString = address.text
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
