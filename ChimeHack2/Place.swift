//
//  Place.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import CoreLocation

class Place: NSObject {
    
    struct Location {
        let id: String
        let city: String
        let country: String
        let state: String
        let street: String?
        let zip: String?
        let coordinate: CLLocationCoordinate2D
        
        init?(dictionary: [String: AnyObject]) {
            if let id = dictionary["id"] as? String, city = dictionary["city"] as? String, country = dictionary["country"] as? String, state = dictionary["state"] as? String, longitude = dictionary["longitude"] as? Double, latitude = dictionary["latitude"] as? Double {
                self.id = id
                self.city = city
                self.country = country
                self.state = state
                self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.street = dictionary["street"] as? String
                self.zip = dictionary["zip"] as? String
            } else {
                return nil
            }
        }
    }
    
    let id: String?
    let name: String
    let location: Location?
    
    override init() {
        id = ""
        name = ""
        location = nil
        super.init()
    }
    
    init?(dictionary: [String: AnyObject]) {
        if let name = dictionary["name"] as? String {
            self.id = dictionary["id"] as? String
            self.name = name
            if let serializedLocation = dictionary["location"] as? [String: AnyObject] {
                self.location = Location(dictionary: serializedLocation)
            } else {
                self.location = nil
            }
            super.init()
        } else {
            self.id = ""
            self.name = ""
            self.location = nil
            super.init()
            return nil
        }
    }
}
