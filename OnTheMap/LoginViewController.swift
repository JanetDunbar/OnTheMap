//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 6/1/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
   
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var udacityImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBAction func loginToFacebook(sender: FBSDKLoginButton) {
        
        let client = Client()
        client.facebookLogin()
        //completeLogin()
        var token = FBSDKAccessToken.currentAccessToken
        println("token is \(token)")
        var token2 = FBSDKAccessToken.currentAccessToken()
        if (token2 != nil){
            println("token2: \(token2)")
            completeLogin()
        } else {
            println("didn't get token2")
        }
        
    }
    
    @IBAction func visitUdacity(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://udacity.com")!)
        
    }
    
    func updateDebugLabel(string: String) {
        self.debugLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.debugLabel.text! = string
            self.debugLabel.fadeIn()
        })
    }
    
    @IBAction func login(sender: AnyObject) {
        
        // Create dictionary of userNames and passwords
        var udacity = ["username": "", "password": ""]
        udacity["username"] = username.text
        //println("username = /(username.text)")
        udacity["password"] = password.text
        let un = username.text
        let pwd = password.text

//        if  un  == "" || pwd  == ""{
//            displayAlert("Please enter your user name and password.")
//        }
//        
        
        let client = Client()
        client.loginWithClient(un, pw: pwd){success, errorString in
            println(success)
            println(errorString)
            if success{
                self.completeLogin()
            }
            else{
                //println("TODO:  Put alert here")
                dispatch_async(dispatch_get_main_queue(), {
                    self.debugLabel.text! = "Then try again."
                    self.updateDebugLabel("Then try again.")
                    switch (errorString){
                        case "bad request": self.debugLabel.text! = "Please re-enter your \n email and password."
                        case "forbidden": self.debugLabel.text! = "Please re-enter your \n email and password."
                    default: self.debugLabel.text! = errorString
                    }
                    
                //self.displayAlert(errorString)
                })
            }
        
        }
        //client.getStudentLocations()
    }
    
    
    
    // Working code from experiment project:  use in view controllers
    func displayAlert(errorMessage: String){
    
            let alertController = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .Alert)
    
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        username.delegate = self
        password.delegate = self
        udacityImage.image = UIImage(named: "udacity")
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("Not logged in")
            
        } else {
            
            println("Logged in")
        }

        
        facebookLoginButton.delegate = self
        
//        if let token = FBSDKAccessToken.currentAccessToken?{
//            completeLogin()
//        }
//        var token = FBSDKAccessToken.currentAccessToken
//        println("token is \(token)")
//        var token2 = FBSDKAccessToken.currentAccessToken()
//        if (token2 != nil){
//            println("token2: \(token2)")
//            completeLogin()
//        } else {
//            println("didn't get token2")
//        }
        
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("Not logged in")
            
        } else {
            
            println("Logged in")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            
        }
    
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
    

    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
        
//        self.debugLabel.text = ""
//        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
//        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: Facebook login delegate methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    
        if error == nil {
            
            println("Login completed.")
            completeLogin()
            
        } else {
            println(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User is logged out.")
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
