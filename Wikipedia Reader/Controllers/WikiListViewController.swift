//
//  WikiListViewController.swift
//  Wikipedia Reader
//
//  Created by Sergii Lantratov on 3/14/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class WikiListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var detailViewController: WikiPageViewController? = nil
    
    private var selectedIndexPath: NSIndexPath? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController
        {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? WikiPageViewController
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("dataSourceUpdated"), name: "UpdateWikiPagesDataSource", object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool)
    {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    
    // MARK: Actions handlers
    
    func insertNewObject(sender: AnyObject)
    {
        self.selectedIndexPath = nil
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    func dataSourceUpdated()
    {
        self.tableView.reloadData()
    }

    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail"
        {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WikiPageViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            if let indexPath = self.selectedIndexPath
            {
                let page = WikiPagesDataSource.dataSource.pages[indexPath.row]
            
                controller.wikiPage = page
                //controller.wikiURL = page.url
                //controller.wikiPageHTMLString = page.htmlString
            }
        }
    }

    
    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return WikiPagesDataSource.dataSource.pages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(WikiPageCell.identifier, forIndexPath: indexPath) as! WikiPageCell

        cell.setupWithPage(WikiPagesDataSource.dataSource.pages[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            WikiPagesDataSource.dataSource.removeAtIndex(indexPath.row)
            //
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.selectedIndexPath = indexPath
    }

}

