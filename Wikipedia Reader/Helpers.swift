//
//  Helpers.swift
//  Wikipedia Reader
//
//  Created by Sergii Lantratov on 3/15/16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation

func getReadableString(str: String) -> String
{
    return str.stringByReplacingOccurrencesOfString("_", withString: " ")
}