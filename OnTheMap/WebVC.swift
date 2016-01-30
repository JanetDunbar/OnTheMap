//
//  WebVC.swift
//  OnTheMap
//
//  Created by Dr. Janet M. Dunbar on 7/26/15.
//  Copyright (c) 2015 Dr. Janet M. Dunbar. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, UISearchBarDelegate, UIWebViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: UIWebView!
    var urlText: String!
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        let text = searchBar.text
        let url = NSURL(string: text!)  //type "http://www.apple.com"
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.delegate = self
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.text = urlText
        let url = NSURL(string: searchBar.text!)  //type "http://www.apple.com"
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }

    @IBAction func dismissWebVC(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
