//
//  WikiPage.swift
//  Wikipedia Reader
//
//  Created by Sergii Lantratov on 3/15/16.
//  Copyright © 2016 Home. All rights reserved.
//


import Foundation


class WikiPage: NSObject, NSCoding
{
    let url: NSURL!
    var htmlString: String?
    
    init(url: NSURL, htmlString: String?)
    {
        self.url = url
        self.htmlString = htmlString
        
        super.init()
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder)
    {
        self.url = aDecoder.decodeObjectForKey("url") as! NSURL
        self.htmlString = aDecoder.decodeObjectForKey("htmlString") as? String
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.url, forKey: "url")
        aCoder.encodeObject(self.htmlString, forKey: "htmlString")
    }
}
