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
        let token = FBSDKAccessToken.currentAccessToken()
        if (token != nil){
            completeLogin()
        } else {
            print("Facebook login failed, didn't receive token")
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
        udacity["password"] = password.text
        let un = username.text
        let pwd = password.text
        
        let client = Client()
        client.loginWithClient(un, pw: pwd){success, errorString in
            
            if success{
                self.completeLogin()
            }
            else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.debugLabel.text! = "Then try again."
                    self.updateDebugLabel("Then try again.")
                    switch (errorString){
                        case "bad request": self.debugLabel.text! = "Please re-enter your \n email and password."
                        case "forbidden": self.debugLabel.text! = "Please re-enter your \n email and password."
                    default: self.debugLabel.text! = errorString
                    }
                })
            }
        }
    }
    
    // Display alert with Login Error message.
    func displayAlert(errorMessage: String){
    
            let alertController = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: .Alert)
    
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        username.delegate = self
        password.delegate = self
        udacityImage.image = UIImage(named: "udacity")
        facebookLoginButton.delegate = self
    }
    
    // Logout from Facebook using FBSDKLoginManager.
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            
        } else {
            
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            
        }
    
    }
    
    // After typing in a textField, user presses return to end input for that textField.
    func textFieldShouldReturn(textField:UITextField)->Bool{
        
        textField.resignFirstResponder()
        return true
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    // MARK: Facebook login delegate methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    
        if error == nil {
            
            completeLogin()
            
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User is logged out.")
    }
}
