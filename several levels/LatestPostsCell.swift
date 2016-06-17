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
    
    lazy var postT: UILabel = UILabel();
    lazy var postD: UILabel = UILabel();
    lazy var postI: UIImageView = UIImageView();
    
    lazy var padding : CGFloat = 20;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //myLabel.frame = CGRect(x: 20, y: 0, width: 70, height: 30)
        postT.frame = CGRectMake(10, padding, self.contentView.frame.size.width - 20, 1)
        
        //Title color is black...
        postT.textColor = UIColor.blackColor()
        
        //Title alignment is center...
        postT.textAlignment = NSTextAlignment.Left
        
        //Break long titles by word wrap
        postT.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        //Font size 24px...
        postT.font = UIFont.systemFontOfSize(20.0)
        
        //Number of line 0. Must be set to 0 to accomodate varying title lengths
        postT.numberOfLines = 1
        
        //This is resizes the height of the title label to accomodate title text. That's why the CGRect height was set to 1px.
        postT.sizeToFit()
        
        self.contentView.addSubview(postT)
        
        // programatically add date to cell
        postD.frame = CGRectMake(10, (padding + 10 + postT.frame.height), self.contentView.frame.size.width - 20, 10)
        postD.textColor = UIColor.grayColor()
        postD.font = UIFont(name: postD.font.fontName, size: 12)
        postD.textAlignment = NSTextAlignment.Left
        self.contentView.addSubview(postD)
        
        
        // programatically add image
        postI.frame = CGRect(x: 10, y: (padding + postT.frame.height + postD.frame.height), width: self.contentView.frame.size.width - 20, height: 140)
        postI.contentMode = .ScaleAspectFill
        postI.clipsToBounds = true
        self.contentView.addSubview(postI)
        
        
    }

}
