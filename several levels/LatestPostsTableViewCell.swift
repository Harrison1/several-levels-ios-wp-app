//
//  LatestPostsTableViewCell.swift
//  several levels
//
//  Created by Harrison McGuire on 6/7/16.
//  Copyright © 2016 severallevels. All rights reserved.
//

import UIKit

class LatestPostsTableViewCell: UITableViewCell {
    
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var postImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
