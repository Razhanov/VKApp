//
//  AllGroupsController.swift
//  Weather
//
//  Created by Karim Razhanov on 04/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import RealmSwift

class AllGroupsController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    


    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    var groups = [AllGroups]()
//    var groupsLogo = [
//            UIImage(named: "GeekBrainsLogo"),
//            UIImage(named: "ArsenalNewsLogo"),
//            UIImage(named: "WorldCupLogo")
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let vkService = VKService()
        vkService.searchGroup(search: searchBar.text!, token: token!, completion: { response in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.groups = response
                strongSelf.tableView?.reloadData()
            }
        })
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as! AllGroupsCell
        let group = groups[indexPath.row]
//        let groupLogo = groupsLogo[indexPath.row]
        let urlImage = URL(string: group.photo50)
//        let session = URLSession(configuration: .default)
//        let getImage = session.dataTask(with: urlImage!) { (data, response, error) in
//            let image = UIImage(data: data!)
//            cell.AllGroupLogo.image = image
//        }
//        getImage.resume()
        cell.AllGroupName.text = group.name
        cell.AllGroupLogo.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))
//        cell.AllGroupLogo.image = groupLogo
        return cell
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        groups = searchText.isEmpty ? groups : groups.filter { (item : AllGroups) -> Bool in
//            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
//        tableView.reloadData()
//    }

    func updateSearchResults(for searchController: UISearchController) {        
        self.tableView.reloadData()
    }
    }


class AllGroups: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var screenName = ""
    @objc dynamic var isClosed:Int = 0
    @objc dynamic var type = ""
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var membersCount: Int = 0
    @objc dynamic var photo50 = ""
    @objc dynamic var photo100 = ""
    @objc dynamic var photo200 = ""
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.screenName = json["screen_name"].stringValue
        self.isClosed = json["is_closed"].intValue
        self.type = json["type"].stringValue
        self.isAdmin = json["is_admin"].intValue
        self.isMember = json["is_member"].intValue
        self.membersCount = json["members_count"].intValue
        self.photo50 = json["photo_50"].stringValue
        self.photo100 = json["photo_100"].stringValue
        self.photo200 = json["photo_200"].stringValue
    }
}
