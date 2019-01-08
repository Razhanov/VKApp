//
//  MyFeedCell.swift
//  VK App
//
//  Created by Karim Razhanov on 30/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit

class MyFeedCell: UITableViewCell {
    
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var reposts: UILabel!
    @IBOutlet weak var authorLogo: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postText: UILabel! {
        didSet {
            postText.numberOfLines = 5
        }
    }

    @IBOutlet weak var postImages: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}








