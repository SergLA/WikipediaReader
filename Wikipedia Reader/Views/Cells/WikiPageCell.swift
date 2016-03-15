//
//  WikiPageCell.swift
//  Wikipedia Reader
//
//  Created by Sergii Lantratov on 3/15/16.
//  Copyright © 2016 Home. All rights reserved.
//


import UIKit


class WikiPageCell: UITableViewCell
{
    static let identifier: String = "WikiPageCell"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var storedForOffline: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.storedForOffline.image = self.storedForOffline.image?.imageWithRenderingMode(.AlwaysTemplate) ?? self.storedForOffline.image
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        self.storedForOffline.hidden = true
    }
    
    func setupWithPage(page: WikiPage)
    {
        self.titleLabel!.text = getReadableString(page.url.lastPathComponent!)
        
        if page.htmlString?.characters.count > 0
        {
            self.storedForOffline.hidden = false
        }
    }
}
