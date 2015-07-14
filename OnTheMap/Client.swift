//
//  Client.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import Foundation

class Client {
    
    func loginWithClient(un:String!, pw: String!, completion: (success: Bool, errorString: String)->()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.HTTPBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        // json = { udacity : { username: "foo@bar.com", password: "1234" } }
        //let un = username.text
        //let un = udacity["username"]
        //let pw = password.text
        //let pw = udacity["password"]
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(un)\", \"password\": \"\(pw)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        //println("LoginVC request.HTTPBody = \(request.HTTPBody)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                //println("!!!!!!!!!!!Error not nil")
                completion(success: false, errorString: "Failed to connect.")
                return
            }

            if let httpResponse = response as? NSHTTPURLResponse{
                println("httpResponse = \(httpResponse)")
                println("httpResponse.statusCode = \(httpResponse.statusCode)")
                println(NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode))
                let errorMessage = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
                
                switch httpResponse.statusCode{
                
                case 200...299:
                    println("\(httpResponse.statusCode) is a success status.")
                default:
                    println("\(httpResponse.statusCode) is not a valid status.")
                    completion(success: false, errorString: errorMessage)
                    return
                }
                
            }
            
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let loginString = NSString(data: newData, encoding: NSUTF8StringEncoding) //as! String
            println("loginString = \(loginString)")
            // Success so call completion
            completion(success: true, errorString: "")
            
            

       }
        // Needed
        task.resume()
        
    }
    
    // Get student locations, via Parse API.  TODO: Change!!!!Using small number for testing.  Need alert?
    func getStudentLocations(completion: (success: Bool, errorString: String)->()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=10")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // !!!!!!!!Handle error...
                println("!!!!error in getStudentLocations")
                completion(success: false, errorString: "error from server")
                return
            }
            
            var err: NSError?
            
            //var options
            //let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("studentLocationsString = \(studentLocationsString)")
            
            if let convertedString: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err){
                //println(convertedString)
                let dict = convertedString as! NSDictionary
                //println(dict)
                //let swiftDict:Dictionary = dict
                if let results = dict.valueForKey("results") as? [[String : AnyObject]] {
                    //var students = StudentInformation.studentInformationFromResults(results)
                    Model.sharedInstance.students = StudentInformation.studentInformationFromResults(results)
                    // Update model singleton with current data from server
                    var students = Model.sharedInstance.students
                    println("getStudentLocations: students[0] = \(students[0])")
                    
                    completion(success: true, errorString: "")
                    return
                    //self.completeLogin()
                }
                else {
                    println("error from conversion = \(err)")
                    completion(success: false, errorString: "error from results not found")
                    return
                }
            }
            else{
                println("error from conversion = \(err)")
                completion(success: false, errorString: "error from conversion")
                return
            }
        }
        
        task.resume()
    }

    //Working code for alert view generation.
//    func alertHelper(viewController: UIViewController){
//        
//        let alertController = UIAlertController(title: "Alert Popup", message: "Please try again.", preferredStyle: .Alert)
//        
//        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//        alertController.addAction(defaultAction)
//        
//        viewController.presentViewController(alertController, animated: true, completion: nil)
//    }

    // Working code from experiment project:  use in view controllers
//    @IBAction func experiment(){
//        
//        let alertController = UIAlertController(title: "Alert Popup", message: "Please try again.", preferredStyle: .Alert)
//        
//        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//        alertController.addAction(defaultAction)
//        
//        presentViewController(alertController, animated: true, completion: nil)
//        
//        
//    }
    
}
