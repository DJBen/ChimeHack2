//
//  WatcherViewController.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

// 我是你的守望者

import UIKit
import Cartography

class WatcherViewController: UIViewController {
    
    var event: Event! {
        didSet {
            let dateString = dateFormatter.stringFromDate(event.startTime)
            titleLabel.text = "\(event.name)"
            timeLabel.text = "\(dateString)"
        }
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .Center
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 28)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .Center
        return label
    }()
    
    private lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
    }()
    
    lazy var watchButton: UIButton = {
        let button = UIButton.buttonWithType(.Custom) as! UIButton
        button.addTarget(self, action: "watchMe:", forControlEvents: .TouchUpInside)
        button.titleLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        button.setTitle("Watch Me", forState: .Normal)
        button.setTitleColor(UIColor(red: 22/255.0, green: 19/255.0, blue: 59/255.0, alpha: 1), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton.buttonWithType(.Custom) as! UIButton
        button.addTarget(self, action: "backToLastScreen:", forControlEvents: .TouchUpInside)
        button.layer.shadowColor = UIColor(red: 97/255.0, green: 159/255.0, blue: 180/255.0, alpha: 1).CGColor
        button.backgroundColor = UIColor(red: 133/255.0, green: 76/255.0, blue: 218/255.0, alpha: 1)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        button.setImage(UIImage(named: "icon_cancel"), forState: .Normal)
        button.tintColor = UIColor.whiteColor()
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        return button
    }()
    
    lazy var greenView: UIView = {
        let view = UIView(frame: CGRectMake(0, 0, 200, 200))
        view.layer.cornerRadius = min(view.frame.size.width, view.frame.size.height) / 2
        view.layer.shadowColor = UIColor(red: 97/255.0, green: 159/255.0, blue: 180/255.0, alpha: 1).CGColor
        view.backgroundColor = UIColor(red: 122/255.0, green: 226/255.0, blue: 200/255.0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private var watched: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("watched_\(event.id)")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "watched_\(event.id)")
        }
    }
    
    override func awakeFromNib() {
        setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.adjustWatchSize()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.layer.cornerRadius = min(backButton.frame.size.width, backButton.frame.size.height) / 2
    }
    
    func watchMe(sender: UIButton) {
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
            self.watched = !self.watched
            self.adjustWatchSize()
        }) { (completed) -> Void in
            
        }
    }
    
    func backToLastScreen(sender: UIButton) {
        navigationController!.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupViews() {
        view.clipsToBounds = true
        view.addSubview(greenView)
        view.addSubview(watchButton)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        
        constrain(watchButton, backButton, titleLabel) { w, b, t in
            w.center == w.superview!.center
            w.leading >= w.superview!.leadingMargin ~ 900
            w.width == w.height
            w.width >= 200
            
            b.centerX == w.centerX
            b.width == 80
            b.height == b.width
            b.bottom == b.superview!.bottomMargin - 20
            
            t.leading == t.superview!.leadingMargin + 20
            t.trailing == t.superview!.trailingMargin - 20
        }
        
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 10))
        
        constrain(titleLabel, timeLabel) { t, m in
            m.top == t.bottom + 10
            m.leading == t.leading
            m.trailing == t.trailing
        }
        
        layout(watchButton, greenView) { w, g in
            g.width == g.height
            g.width == w.width
            g.center == w.center
        }
    }
    
    private func adjustWatchSize() {
        if self.watched {
            self.greenView.transform = CGAffineTransformMakeScale(4, 4)
            watchButton.setTitle("Watched!", forState: .Normal)
            watchButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            self.greenView.transform = CGAffineTransformIdentity
            watchButton.setTitle("Watch Me", forState: .Normal)
            watchButton.setTitleColor(UIColor(red: 22/255.0, green: 19/255.0, blue: 59/255.0, alpha: 1), forState: .Normal)
        }
    }

}
