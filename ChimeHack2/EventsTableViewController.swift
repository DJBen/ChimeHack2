//
//  EventsTableViewController.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import Cartography
import FBSDKCoreKit
import FBSDKLoginKit

class EventsTableViewController: UITableViewController {
    
    static let EventTableViewCellIdentifier = "EventTableViewCell"
    static let WatcherViewControllerSegueIdentifier = "watch"
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EventsTableViewController.EventTableViewCellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        cell.loadEvent(events[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let event = events[indexPath.row]
        performSegueWithIdentifier(EventsTableViewController.WatcherViewControllerSegueIdentifier, sender: event)
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == EventsTableViewController.WatcherViewControllerSegueIdentifier {
            let event = sender as! Event
            let vc = segue.destinationViewController as! WatcherViewController
            vc.event = event
        }
    }

    
    // MARK: - Private methods
    
    private func setupViews() {
        tableView.registerClass(EventTableViewCell.self, forCellReuseIdentifier: EventsTableViewController.EventTableViewCellIdentifier)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchEvents() {
        CHM.getEvents { (events, error) -> Void in
            self.events = events
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }
    
}
