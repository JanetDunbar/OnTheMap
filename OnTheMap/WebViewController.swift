//
//  WebViewController.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 7/25/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate {

//class WebViewController: UIViewController {

    @IBOutlet var myActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var myWebView: UIWebView!
    var htmlString = "Bold string"
    //let url = "http://apple.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.delegate = self
//        myWebView.loadHTMLString(htmlString, baseURL: nil)

//        let myURL = NSURL(string: "http://www.swiftdeveloperblog.com");
//        let myURLRequest:NSURLRequest = NSURLRequest(URL: myURL!);
//        myWebView.loadRequest(myURLRequest);
        
        let requestURL = NSURL(string:htmlString)
        let request = NSURLRequest(URL: requestURL!)
        myWebView.loadRequest(request)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
//    func webViewDidStartLoad(webView: UIWebView)
//    {
//        myActivityIndicator.startAnimating()
//    }
//    func webViewDidFinishLoad(webView: UIWebView)
//    {
//        myActivityIndicator.stopAnimating()
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
