//
//  Event.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import CoreLocation

class Event: NSObject, Printable {
    enum RSVPStatus: String {
        case Attending = "attending"
        case Unsure = "unsure"
    }
    let eventDescription: String
    let id: String
    let name: String
    let RSVP: RSVPStatus
    let startTime: NSDate
    let endTime: NSDate
    let place: Place
    
    override var description: String {
        return "\(name) (\(startTime) - \(endTime)): \(RSVP.rawValue)"
    }
    
    // RFC 3339 date-time
    private var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    init?(dictionary: [String: AnyObject]) {
        let data = dictionary
        if let eventDescription = data["description"] as? String, id = data["id"] as? String, name = data["name"] as? String, startTimeString = data["start_time"] as? String, endTimeString = data["end_time"] as? String, rsvpString = data["rsvp_status"] as? String, placeDict = data["place"] as? [String: AnyObject] {
            self.eventDescription = eventDescription
            self.id = id
            self.name = name
            self.RSVP = RSVPStatus(rawValue: rsvpString)!
            self.place = Place(dictionary: placeDict)!
            
            if let startTime = dateFormatter.dateFromString(startTimeString), endTime = dateFormatter.dateFromString(endTimeString) {
                self.startTime = startTime
                self.endTime = endTime
                super.init()
            } else {
                self.startTime = NSDate()
                self.endTime = NSDate()
                super.init()
                return nil
            }

        } else {
            self.eventDescription = ""
            self.id = ""
            self.name = ""
            self.RSVP = .Unsure
            self.startTime = NSDate()
            self.endTime = NSDate()
            self.place = Place()
            super.init()
            return nil
        }
    }
    
    class func eventsFromGraphAPIPayload(payload: [String: AnyObject]) -> [Event] {
        if let data = payload["data"] as? [[String: AnyObject]] {
            return data.flatMap { item -> [Event] in
                if let event = Event(dictionary: item) {
                    return [event]
                } else {
                    return []
                }
            }
        } else {
            return []
        }
    }
}
