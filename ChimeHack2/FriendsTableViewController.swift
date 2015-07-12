//
//  FriendsTableViewController.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/12/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import Parse
import Cartography

let WatchInterval: NSTimeInterval = 10

class FriendsTableViewController: UITableViewController {
    
    var event: Event!
    static let FriendCellIdentifier = "FriendCellIdentifier"
    
    var friends = [String: [String: String]]()
    var timer: NSTimer?
    var info = [String: [String: AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUsers()
    
        timer = NSTimer.scheduledTimerWithTimeInterval(WatchInterval, target: self, selector: "timerTick:", userInfo: nil, repeats: true)
    }
    
    func timerTick(sender: NSTimer) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
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
        return friends.count
    }

    private func retrieveUsers() {
        var ref = Firebase(url:"https://cradle.firebaseIO.com/")
        ref.observeEventType(.Value, withBlock: { snapshot in
            println(snapshot.value)
            if let friends = snapshot.value as? [String: [String: String]] {
                self.friends = friends
                for (i, friendID) in enumerate(self.friends.keys.array) {
                    CHM.getUser(identifier: i, userID: friendID, completion: { (id, name, pictureURL, identifier) -> Void in
                        let subInfo = ["name": name, "url" : pictureURL]
                        self.info[friendID] = subInfo
                        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: identifier, inSection: 0)], withRowAnimation: .Automatic)
                    })
                    
                }
            } else {
                self.friends = [:]
            }
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }, withCancelBlock: { error in
            println(error.description)
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(FriendsTableViewController.FriendCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let friendsList = friends.keys.array
        let id = friendsList[indexPath.row]
        if let url = info[id]?["url"] as? NSURL {
            cell.imageView!.sd_setImageWithURL(url)
        }
        if let name = info[id]?["name"] as? String {
            cell.textLabel!.text = name
        } else {
            cell.textLabel!.text = id
        }
        let events = friends[friendsList[indexPath.row]]!
        if let checkinTime = events["chimehack2"] {
            let date: NSDate = Event.dateFormatter.dateFromString(checkinTime)!
            if NSDate().timeIntervalSinceDate(date) > WatchInterval * 2 {
                cell.detailTextLabel!.text = "!!! Maybe in danger !!!"
            } else {
                cell.detailTextLabel!.text = "Safe"
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = UIAlertController(title: "Notify", message: "Your friend may be in danger", preferredStyle: UIAlertControllerStyle.ActionSheet)
        controller.addAction(UIAlertAction(title: "Call Campus Police", style: UIAlertActionStyle.Destructive, handler: { (_) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://012-345-6789")!)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
