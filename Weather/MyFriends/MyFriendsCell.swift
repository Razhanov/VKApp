//
//  AllFriendsCell.swift
//  Weather
//
//  Created by Karim Razhanov on 04/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {
    
    @IBOutlet weak var MyFriendLogo: UIImageView!
    @IBOutlet weak var MyFriendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
