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
    @IBOutlet weak var storeForOfflienButton: UIBarButtonItem!
    
    var wikiPage: WikiPage?
    {
        didSet
        {
            self.startWikiPageLoading()
        }
    }
    
//    var wikiURL: NSURL?
//    {
//        didSet
//        {
//            self.startWikiPageLoading()
//        }
//    }
//    
//    var wikiPageHTMLString: String?
//    {
//        didSet
//        {
//            self.startWikiPageLoading()
//        }
//    }
    
    private var currentPageURL: NSURL?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.startWikiPageLoading()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("dataSourceUpdated"), name: "UpdateWikiPagesDataSource", object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    // MARK: - Private methods
    
    func startWikiPageLoading()
    {
        if (self.webView.loading)
        {
            self.webView.stopLoading()
        }
        
        self.currentPageURL = nil

        if (self.wikiPage != nil)
        {
            if Reachability.isConnectedToNetwork()
            {
                self.webView.loadRequest(NSURLRequest(URL: self.wikiPage!.url))
            }
            else if self.wikiPage!.htmlString?.characters.count > 0
            {
                self.webView.loadHTMLString(self.wikiPage!.htmlString!, baseURL: nil)
            }
            else
            {
                self.showMessage("There's no Internet Connection to load page...")
            }
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
        
        self.likeButton.image = (self.wikiPage == nil) ? UIImage(named: "heart") : UIImage(named: "heart_fill")
        self.storeForOfflienButton.image = (self.wikiPage?.htmlString?.characters.count == 0) ? UIImage(named: "stored") : UIImage(named: "stored_fill")
    }
    
    func showMessage(message: String)
    {
        let alert = UIAlertController(title: "Wiki Reader", message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions handlers
    
    func dataSourceUpdated()
    {
        self.updateUI()
    }
    
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
        if self.wikiPage == nil
        {
            self.wikiPage = WikiPage(url: self.currentPageURL!, htmlString: nil)
            WikiPagesDataSource.dataSource.addWikiPage(self.wikiPage!)
        }
        else
        {
            // TODO: handle possible race condition there with UI updation.
            WikiPagesDataSource.dataSource.removeWikiPage(self.wikiPage!)
            self.wikiPage = nil
        }
    }
    
    @IBAction func storeForOfflineTouchUpInside(sender: UIBarButtonItem)
    {
        let htmlString = self.webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
        
        if self.wikiPage == nil
        {
            self.wikiPage = WikiPage(url: self.currentPageURL!, htmlString: htmlString)
            WikiPagesDataSource.dataSource.addWikiPage(self.wikiPage!)
        }
        else
        {
            self.wikiPage!.htmlString = htmlString
            WikiPagesDataSource.dataSource.updateData()
        }
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
        self.webView.alpha = 0.35
        
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

