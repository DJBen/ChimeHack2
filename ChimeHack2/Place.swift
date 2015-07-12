//
//  Place.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit

class Place: NSObject {
    let id: String
    
    init?(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? String {
            self.id = id
            super.init()
        } else {
            self.id = ""
            super.init()
            return nil
        }
    }
}
