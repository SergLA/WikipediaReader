//
//  WikiPageViewController.swift
//  Wikipedia Reader
//
//  Created by Sergii Lantratov on 3/14/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit


class WikiPageViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var backWebViewButton: UIButton!
    @IBOutlet weak var forwardWebViewButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    
    var wikiURL: NSURL?
    {
        didSet
        {
            self.startWikiPageLoading()
        }
    }
    
    var wikiPageHTMLString: String?
    {
        didSet
        {
            self.startWikiPageLoading()
        }
    }
    
    private var currentPageURL: NSURL?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.startWikiPageLoading()
    }

    
    // MARK: - Private methods
    
    func startWikiPageLoading()
    {
        if (self.webView.loading)
        {
            return
        }
        
        self.currentPageURL = nil
        
        if let urlToLoad = self.wikiURL
        {
            self.webView.loadRequest(NSURLRequest(URL: urlToLoad))
        }
        else if let htmlStringToLoad = self.wikiPageHTMLString
        {
            self.webView.loadHTMLString(htmlStringToLoad, baseURL: nil)
        }
        else
        {
            let request = NSURLRequest(URL: NSURL(string: "https://en.wikipedia.org/wiki/Special:Random")!)
            self.webView.loadRequest(request)
        }
    }
    
    func updateUI()
    {
        self.backWebViewButton.enabled = self.webView.canGoBack
        self.forwardWebViewButton.enabled = self.webView.canGoForward
    }
    
    
    // MARK: - Actions handlers
    
    @IBAction func refreshTouchUpInside(sender: UIBarButtonItem)
    {
        self.startWikiPageLoading()
    }
    
    @IBAction func shareButtonTouchUpInside(sender: UIBarButtonItem)
    {
        if (self.currentPageURL == nil)
        {
            return
        }
        
        let textToShare = getReadableString(self.currentPageURL!.lastPathComponent!)
        
        let objectsToShare = [textToShare, self.currentPageURL!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        if (activityVC.respondsToSelector(Selector("popoverPresentationController")))
        {
            activityVC.popoverPresentationController?.barButtonItem = self.shareButton
            activityVC.popoverPresentationController?.passthroughViews = nil;
            activityVC.popoverPresentationController?.permittedArrowDirections = .Any
        }
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func likeButtonTouchUpInside(sender: UIBarButtonItem)
    {
        self.likeButton.image = UIImage(named: "heart_fill")
    }
    
    
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if request.URL?.lastPathComponent != "Special:Random"
        {
            self.currentPageURL = request.URL
        }
        
        return true
    }

    func webViewDidStartLoad(webView: UIWebView)
    {
        self.title = "Loading page..."
        
        self.activityIndicator.startAnimating()
        self.webView.alpha = 0.4
        
        self.updateUI()
    }
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        self.title = (self.currentPageURL != nil) ? getReadableString(self.currentPageURL!.lastPathComponent!) : "Wiki Reader"
        
        self.activityIndicator.stopAnimating()
        self.webView.alpha = 1.0
        
        self.updateUI()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        print("\n\nFail to load page: \(webView.request)\n\nError: \(error?.localizedDescription)\n\n")
        
        self.webViewDidFinishLoad(webView)
    }
}

