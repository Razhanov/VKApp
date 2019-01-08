//
//  PeopleController.swift
//  Weather
//
//  Created by Karim Razhanov on 04/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit
class PeopleController: UITableViewController {
    var friends = [
        "Ilon Mask",
        "Karim Razhanov",
        "Pavel Durov"
    ]
    var friendsLogo = [
        UIImage(named: "Mask"),
        UIImage(named: "Me"),
        UIImage(named: "Durov")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! PeopleCell
        let friend = friends[indexPath.row]
        let friendLogo = friendsLogo[indexPath.row]
        cell.PeopleName.text = friend
        cell.PeopleLogo.image = friendLogo
        return cell
    }
}
