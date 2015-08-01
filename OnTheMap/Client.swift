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
    
    // Login to Udacity with user's email and password.
    func loginWithClient(un:String!, pw: String!, completion: (success: Bool, errorString: String)->()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(un)\", \"password\": \"\(pw)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completion(success: false, errorString: "Failed to connect.\nPlease check your settings.")
                return
            }

            if let httpResponse = response as? NSHTTPURLResponse{
                let errorMessage = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
                
                switch httpResponse.statusCode{
                
                case 200...299:
                    println("\(httpResponse.statusCode) is a success status.")
                default:
                    completion(success: false, errorString: errorMessage)
                    return
                }
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let loginString = NSString(data: newData, encoding: NSUTF8StringEncoding) //as! String
            // Success so call completion
            completion(success: true, errorString: "")
 
       }
        task.resume()

    }

    // Get student locations, via Parse API.  
    func getStudentLocations(limit: Int, skip: Int, completion: (success: Bool, errorString: String)->()){
        
        var limitString = "?limit=\(limit)"
        //var skipString = "&skip= \(skip)"
        var skipString = "&skip=\(skip)"
        if skip == 0 {
            skipString = ""
        }
        
        var baseString = "https://api.parse.com/1/classes/StudentLocation"
        var url = baseString + limitString + skipString
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error...
                
                var descrip = error.localizedDescription
                if let reason = error.localizedFailureReason{
                    descrip = ("\(descrip) : \(reason)")
                }
                completion(success: false, errorString: descrip)
                return
            }
            
            var err: NSError?
            
            let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            if let convertedString: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err){

                let dict = convertedString as! NSDictionary
                
                if let results = dict.valueForKey("results") as? [[String : AnyObject]] {
                    Model.sharedInstance.students = Model.sharedInstance.students + StudentInformation.studentInformationFromResults(results)

                    // Update model singleton with current data from server
                    var students = Model.sharedInstance.students
                    
                    completion(success: true, errorString: "")
                    return
                }
                else {
                    completion(success: false, errorString: "error from results not found")
                    return
                }
            }
            else {
                completion(success: false, errorString: "error from conversion")
                return
            }
        }
        
        task.resume()
    }
    
    // Login to Udacity via user's Facebook account
    func facebookLogin(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"DADFMS4SN9e8BAD6vMs6yWuEcrJlMZChFB0ZB0PCLZBY8FPFYxIPy1WOr402QurYWm7hj1ZCoeoXhAk2tekZBIddkYLAtwQ7PuTPGSERwH1DfZC5XSef3TQy1pyuAPBp5JJ364uFuGw6EDaxPZBIZBLg192U8vL7mZAzYUSJsZA8NxcqQgZCKdK4ZBA2l2ZA6Y1ZBWHifSM0slybL9xJm3ZBbTXSBZCMItjnZBH25irLhIvbxj01QmlKKP3iOnl8Ey;\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error...
                println("error in facebookLogin")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        }
        task.resume()
    }
}


