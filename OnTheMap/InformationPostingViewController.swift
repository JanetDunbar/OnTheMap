//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import MapKit


class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var address: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        address.delegate = self

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        //let address = "350 5th Avenue New York, NY"
        println(address)
        let mapString = address.text
        forwardGeocode(mapString)
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
        //self.coords = location.coordinate
        
        println("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        }
        
        })
    }

    
//    func mapLocation(){
//        
//        let coords = CLLocationCoordinate2DMake(40.7483, -73.984911)
//        
//        let place = MKPlacemark(coordinate: coords, addressDictionary: address)
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
