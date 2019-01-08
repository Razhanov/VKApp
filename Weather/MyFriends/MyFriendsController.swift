//
//  AllFriendsController.swift
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

public var idOwner: String?

class MyFriendsController: UITableViewController {
    
    
    var friends = [MyFriend]()
    //var friends: List<MyFriend>!
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vkService = VKService()
        vkService.getFriend(userId: userId!, token: token!, completion: { response in
            //self.loadData()
//            self.friends = response
//            self.tableView?.reloadData()
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.friends = response
                strongSelf.loadData()
                strongSelf.tableView?.reloadData()
            }
        })
    }
    var nToken: NotificationToken?
    func loadData(){
        do {
            let realm = try Realm()
            let friends = realm.objects(MyFriend.self)
            self.nToken = friends.observe {[weak self] (changes: RealmCollectionChange) in
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
            var f = [MyFriend]()
            for friend in Array(friends) {
                f.append(friend)
            }
            self.friends = f
            self.tableView?.reloadData()
        } catch {
            print(error)
        }
    }
//    func pairTableAndRealm() {
//        guard let realm = try? Realm() else {return}
//        let friend = realm.objects(MyFriend.self)
//        friends = friend.friends
//    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        let friend = friends[indexPath.row]
//        let friendLogo = friendsLogo[indexPath.row]
        let urlImage = URL(string: friend.photo50)
//        let session = URLSession(configuration: .default)
//        let getImage = session.dataTask(with: urlImage!) { (data, response, error) in
//            let image = UIImage(data: data!)
//            DispatchQueue.main.async {
//                cell.MyFriendLogo.image = image
//            }
//        }
//        getImage.resume()
        cell.MyFriendLogo.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))
        cell.MyFriendName.text = friend.firstName + " " + friend.lastName
//        idOwner = String(friend.id)
        
        let getCacheImage = GetCacheImage​(url: friend.photo50)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.MyFriendLogo.image = getCacheImage.outputImage
            }
        }
        queue.addOperation(getCacheImage)
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pathIndex = tableView.indexPathForSelectedRow?.row
        let friend = friends[(pathIndex)!]
        idOwner = String(friend.id)
    }

}

//class MyFriend {
//    var response: [MyFriend1]
//    init(json: JSON) {
//        self.response = json["respose"].map { MyFriend1(json: $0.1)}
//    }
//}
//class MyFriend {
//    var count:Int
//    var items: [MyFriend2]
//    init(json: JSON) {
//        self.count = json["count"].intValue
//        self.items = json["items"].map { MyFriend2(json: $0.1)}
//    }
//}
class MyFriend: Object {
    @objc dynamic var count: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var nickname = ""
    @objc dynamic var photo50 = ""
    @objc dynamic var isOnline: Int = 0
    convenience init(json: JSON) {
        self.init()
        self.count = json["count"].intValue
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.nickname = json["nickname"].stringValue
        self.photo50 = json["photo_50"].stringValue
        self.isOnline = json["online"].intValue
    }
}
