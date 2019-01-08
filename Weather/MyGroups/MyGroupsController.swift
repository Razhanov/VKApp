//
//  MyGroupsController.swift
//  Weather
//
//  Created by Karim Razhanov on 04/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import RealmSwift

class MyGroupsController: UITableViewController {
    var groups = [MyGroup]()
//    var groupsLogo = [UIImage]()
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vkService = VKService()
        vkService.getGroupList(userId: userId!, token: token!, completion: { response in
            self.loadData()
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.groups = response
                strongSelf.tableView?.reloadData()
            }
        })
//        loadData()
    }
    var nToken: NotificationToken?
    func loadData(){
        do {
            let realm = try Realm()
            let groups = realm.objects(MyGroup.self)
            self.nToken = groups.observe {[weak self] (changes: RealmCollectionChange) in
                switch changes {
                case .initial(let results):
                    self?.tableView?.reloadData()
                case let .update(results, deletions, insertions, modifications):
                    self?.tableView?.beginUpdates()
                    self?.tableView.insertRows(at: insertions.map( { IndexPath(row: $0, section: 0)}), with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self?.tableView.endUpdates()
                case .error(let error):
                    print(error)
                }
                print("Data is changed")
            }
            //let f = List<MyFriend>()
            var g = [MyGroup]()
            for group in Array(groups) {
                g.append(group)
            }
            self.groups = g
            self.tableView?.reloadData()
        } catch {
            print(error)
        }
    }

    //"​https://jsonplaceholder.typicode.com/users"
    
//    func loadData() {
//        let url = URL(string: "​https://jsonplaceholder.typicode.com/users")!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                    return
//            }
//            do {
//                let json = try JSON(data: data)
//                for (_, myFriendJson) in json {
//                    let id = myFriendJson["id"].intValue
//                    let firstName = myFriendJson["first_name"].stringValue
//                    let lastName = myFriendJson["last_name"].stringValue
//                    let nickname = myFriendJson["nickname"].stringValue
//                    let isOnline = myFriendJson["online"].intValue
//                    print(id, firstName, lastName, nickname, isOnline)
//                }
//            }
//            catch {
//
//            }
//        }.resume()
//    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupsCell
        let group = groups[indexPath.row]
//        let groupLogo = groupsLogo[indexPath.row]
        cell.MyGroupName.text = group.name
        let urlImage = URL(string: group.photo50)
//        let session = URLSession(configuration: .default)
//        let getImage = session.dataTask(with: urlImage!) { (data, response, error) in
//            let image = UIImage(data: data!)
//            cell.MyGroupLogo.image = image
//        }
//        getImage.resume()
//        cell.MyGroupLogo.image = groupLogo
        cell.MyGroupLogo.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))

        let getCacheImage = GetCacheImage​(url: group.photo50)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.MyGroupLogo.image = getCacheImage.outputImage
            }
        }
        queue.addOperation(getCacheImage)
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsController = segue.source as! AllGroupsController
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                let group = allGroupsController.groups[indexPath.row]
//                let groupLogo = allGroupsController.groupsLogo[indexPath.row]
//                if !groups.contains(group){
//                    groups.append(group)
////                    groupsLogo.append(groupLogo!)
//                    tableView.reloadData()
//                }
            }
        }
    }
}

class MyGroup: Object {
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
        self.membersCount = json["member_count"].intValue
        self.photo50 = json["photo_50"].stringValue
        self.photo100 = json["photo_100"].stringValue
        self.photo200 = json["photo_200"].stringValue
    }
}







