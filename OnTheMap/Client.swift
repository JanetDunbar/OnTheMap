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
                    print("\(httpResponse.statusCode) is a success status.")
                default:
                    completion(success: false, errorString: errorMessage)
                    return
                }
            }
            
            // Success so call completion
            completion(success: true, errorString: "")
 
       }
        task.resume()

    }

    // Overloaded variant of getStudentLocations which uses model for limit and skip.
    func getStudentLocations(completion: (success: Bool, errorString: String)->()){
        
        getStudentLocations(Model.sharedInstance.batchSize, skip: Model.sharedInstance.students.count, completion: completion)
    }

    // Get student locations, via Parse API.  
    func getStudentLocations(limit: Int, skip: Int, completion: (success: Bool, errorString: String)->()){
        
        let limitString = "?limit=\(limit)"
        var skipString = "&skip=\(skip)"
        if skip == 0 {
            skipString = ""
        }
        
        let baseString = "https://api.parse.com/1/classes/StudentLocation"
        let url = baseString + limitString + skipString
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error...
                
                var descrip = error!.localizedDescription
                if let reason = error!.localizedFailureReason{
                    descrip = ("\(descrip) : \(reason)")
                }
                completion(success: false, errorString: descrip)
                return
            }
        
            do {
                let convertedString: AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))

                let dict = convertedString as! NSDictionary
                
                if let results = dict.valueForKey("results") as? [[String : AnyObject]] {
                    
                    print("getStudentLocations: results.count: \(StudentInformation.studentInformationFromResults(results).count); skip: \(skip); limit: \(limit)")
                    
                    // Add new batch to the model.
                    Model.sharedInstance.students = Model.sharedInstance.students + StudentInformation.studentInformationFromResults(results)
                    
                    print("getStudentLocations: New model count: \(Model.sharedInstance.students.count)")
                    print("batchNumber = \(Model.sharedInstance.batchNumber)")
                    
                    completion(success: true, errorString: "")
                    return
                }
                else {
                    completion(success: false, errorString: "error from results not found")
                    return
                }
            } catch let error as NSError {
                
                completion(success: false, errorString: "error from conversion: \(error)")
                return
            } catch {
                fatalError()
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
                print("error in facebookLogin")
                return
            }
        }
        task.resume()
    }
}


