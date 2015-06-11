//
//  ViewController.swift
//  ProductHunt
//
//  Created by Remi Robert on 11/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import Foundation
import WebKit
import AppKit
import Cocoa

class ViewController: NSViewController, WKNavigationDelegate {

    @IBOutlet var webView: WebView!
    @IBOutlet var imageView: NSImageView!
    let webUrl = "http://www.producthunt.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.policyDelegate = self
        webView.drawsBackground = false
        webView.frameLoadDelegate = self
        loadWebRequest()
    }

    func loadWebRequest() {
        if let url = NSURL(string: webUrl) {
            let request = NSMutableURLRequest(URL: url)
            webView.mainFrame.loadRequest(request)
        }
    }
    
    func webView(sender: WKWebView,
        decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
            if sender == webView {
                if let url = navigationAction.request.URL {
                    NSWorkspace.sharedWorkspace().openURL(url)
                }
            }
    }
    
    override func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        imageView.alphaValue = 0
        imageView.hidden = true
    }
    
    override func webView(sender: WebView!, decidePolicyForNavigationAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        listener.use()
    }
    
    override func webView(webView: WebView!, decidePolicyForNewWindowAction actionInformation: [NSObject : AnyObject]!, request: NSURLRequest!, newFrameName frameName: String!, decisionListener listener: WebPolicyDecisionListener!) {
        if let linkUrl = actionInformation["WebActionOriginalURLKey"]?.absoluteString {
            if let url = NSURL(string: linkUrl!) {
                NSWorkspace.sharedWorkspace().openURL(url)
            }
        }
        listener.ignore()
    }
    
    override func webView(sender: WebView!, resource identifier: AnyObject!, willSendRequest request: NSURLRequest!, redirectResponse: NSURLResponse!, fromDataSource dataSource: WebDataSource!) -> NSURLRequest! {
        if let url = request.URL {
            return NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: request.timeoutInterval)
        }
        return nil
    }
}

