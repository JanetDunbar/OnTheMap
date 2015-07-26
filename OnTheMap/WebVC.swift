//
//  WebVC.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 7/26/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: UIWebView!
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        var text = searchBar.text
        var url = NSURL(string: text)  //type "http://www.apple.com"
        var req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissWebVC(sender: UIBarButtonItem) {
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