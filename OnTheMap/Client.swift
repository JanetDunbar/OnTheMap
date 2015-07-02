//
//  Client.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import Foundation

class Client {
    
    func loginWithClient(un:String!, pw: String!){
        
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
        println("LoginVC request.HTTPBody = \(request.HTTPBody)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let loginString = NSString(data: newData, encoding: NSUTF8StringEncoding) as! String
            println("loginString = \(loginString)")
            /*
            Optional({"account": {"registered": true, "key": "280195754"}, "session": {"id": "1464816385Sb5f1302a6d754bd54a7f63d5bb85bc9b", "expiration": "2015-08-01T21:26:25.946330Z"}})
            */
            //TODO: ?Convert NSString optional to JSON.  Then convert JSON to swift object?
        }
        task.resume()
        
    }
    
    // Get student locations, via Parse API.  TODO: Change!!!!Using small number for testing.  Need alert?
    func getStudentLocations(completion: ()->()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // !!!!!!!!Handle error...
                return
            }
            
            var err: NSError?
            
            //var options
            //let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("studentLocationsString = \(studentLocationsString)")
            //let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
            //options: NSJSONReadingOptions(0), error: &error)
            /*
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as! NSDictionary
            //println(convertedString)
            //let dict = convertedString as! NSDictionary
            println(dict)
            //let swiftDict:Dictionary = dict
            if let results = dict.valueForKey("results") as? [[String : AnyObject]] {
            var students = StudentInformation.studentInformationFromResults(results)
            }
            */
            
            if let convertedString: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err){
                println(convertedString)
                let dict = convertedString as! NSDictionary
                println(dict)
                //let swiftDict:Dictionary = dict
                if let results = dict.valueForKey("results") as? [[String : AnyObject]] {
                    //var students = StudentInformation.studentInformationFromResults(results)
                    Model.sharedInstance.students = StudentInformation.studentInformationFromResults(results)
                    // Update model singleton with current data from server
                    var students = Model.sharedInstance.students
                    //println(students[0])
                    
                    completion()
                    //self.completeLogin()
                }
            }
            else{
                println("error from conversion = \(err)")
            }
        }
        
        task.resume()
    }
    
    
    
}
