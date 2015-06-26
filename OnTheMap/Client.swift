//
//  Client.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import Foundation

class Client {
    
    func loginToUdacity(un:String!, pw: String!){
        
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
        
        // TODO:!!!! Is now in login func of LoginViewController-move?????
        //getStudentLocations()
    }
    
}
