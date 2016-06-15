//
//  LatestPostsCell.swift
//  several levels
//
//  Created by Harrison McGuire on 6/14/16.
//  Copyright © 2016 severallevels. All rights reserved.
//

import UIKit

class LatestPostsCell: UITableViewCell {

    @IBOutlet var postTitleH: UILabel!
    @IBOutlet var postDateH: UILabel!
    @IBOutlet var postImageH: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
