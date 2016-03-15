//
//  WikiPagesDataSource.swift
//  Wikipedia Reader
//
//  Created by Sergii Lantratov on 3/15/16.
//  Copyright © 2016 Home. All rights reserved.
//


import Foundation


class WikiPagesDataSource: NSObject
{
    static let dataSource: WikiPagesDataSource = WikiPagesDataSource()
    
    var pages: Array<WikiPage> = []
    
    override init()
    {
        super.init()

        if NSFileManager.defaultManager().fileExistsAtPath(self.fileName())
        {
            if let tmpPages = NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileName()) as? Array<WikiPage>
            {
                if tmpPages.count > 0
                {
                    self.pages = tmpPages
                }
            }
        }
    }
    
    
    // MARK: Public methods
    
    func addWikiPage(newPage: WikiPage)
    {
        self.pages.append(newPage)
        
        self.updateData()
    }
    
    func removeWikiPage(wikiPage: WikiPage)
    {
        if let indexToRemove = self.pages.indexOf(wikiPage)
        {
            self.removeAtIndex(indexToRemove)
        }
    }
    
    func removeAtIndex(index: Int)
    {
        if ((index >= 0) &&
            (index < self.pages.count))
        {
            self.pages.removeAtIndex(index)
            
            self.updateData()
        }
    }
    
    func updateData()
    {
        self.savePages()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateWikiPagesDataSource", object: nil)
    }
    
    
    // MARK: Private methods
    
    private func fileName() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        return (paths[0] as NSString).stringByAppendingPathExtension("wiki_pages.wpgs")!
    }
    
    private func savePages()
    {
        NSKeyedArchiver.archiveRootObject(self.pages, toFile: self.fileName())
    }
}