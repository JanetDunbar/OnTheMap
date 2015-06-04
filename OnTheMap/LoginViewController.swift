//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import Foundation


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBAction func login(sender: AnyObject) {
        
        // Create dictionary of userNames and passwords
        var udacity = ["username": "", "password": ""]
        udacity["username"] = username.text
        //println("username = /(username.text)")
        udacity["password"] = password.text
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        // json = { udacity : { username: "foo@bar.com", password: "1234" } }
        let un = username.text
        let pw = password.text
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(un)\", \"password\": \"\(pw)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let loginString = NSString(data: newData, encoding: NSUTF8StringEncoding) as! String
            println(loginString)
            /*
            Optional({"account": {"registered": true, "key": "280195754"}, "session": {"id": "1464816385Sb5f1302a6d754bd54a7f63d5bb85bc9b", "expiration": "2015-08-01T21:26:25.946330Z"}})
            */
            //TODO: ?Convert NSString optional to JSON.  Then convert JSON to swift object?
        }
        task.resume()
        getStudentLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        username.delegate = self
        password.delegate = self
    }
    
    // After typing in a textField, user presses return to end input for that textField.
    func textFieldShouldReturn(textField:UITextField)->Bool{
        
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get student locations, via Parse API.  TODO: Change!!!!Using small number for testing
    func getStudentLocations(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=3")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            var err: NSError?
            
            //var options
            //let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            let studentLocationsString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(studentLocationsString)
            //let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
            //options: NSJSONReadingOptions(0), error: &error)
            if let convertedString: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err){
                println(convertedString)
                let dict = convertedString as! NSDictionary
                println(dict)            }
            else{
                println("error from conversion = \(err)")
            }
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
