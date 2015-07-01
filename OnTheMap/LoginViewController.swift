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

    @IBOutlet weak var udacityImage: UIImageView!
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
        let un = username.text
        let pwd = password.text
        let client = Client()
        client.loginWithClient(un, pw: pwd)
        //client.getStudentLocations()
        completeLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        username.delegate = self
        password.delegate = self
        udacityImage.image = UIImage(named: "udacity")
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
