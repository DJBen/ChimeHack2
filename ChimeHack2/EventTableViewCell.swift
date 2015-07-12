//
//  EventTableViewCell.swift
//  ChimeHack2
//
//  Created by Ben Lu on 7/11/15.
//  Copyright (c) 2015 DJ.Ben. All rights reserved.
//

import UIKit
import Cartography

class EventTableViewCell: UITableViewCell {

    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var eventDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.lineBreakMode = .ByWordWrapping
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadEvent(event: Event) {
        eventNameLabel.text = event.name
        eventDescription.text = event.eventDescription
        if let cover = event.cover {
            iconView.sd_setImageWithURL(cover.sourceURL, completed: { (image, error, cacheType, url) -> Void in
                
            })
        }
    }
    
    private func setupViews() {
        contentView.addSubview(iconView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventDescription)
        
        layout(iconView, eventNameLabel, eventDescription) { i, n, d in
            i.height == i.width
            i.leading == i.superview!.leadingMargin
            i.centerY == i.superview!.centerY
            i.height == 50
            
            n.leading == i.trailing + 10
            n.top == n.superview!.topMargin
            n.bottom == d.top - 4
            n.trailing == n.superview!.trailingMargin
            
            d.leading == n.leading
            d.trailing == n.trailing
            d.bottom == d.superview!.bottomMargin
        }
    }

}
