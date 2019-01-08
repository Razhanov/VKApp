//
//  MyFeedController.swift
//  VK App
//
//  Created by Karim Razhanov on 30/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import RealmSwift

class MyFeedController: UITableViewController {
    
    var allFeed = [MyFeed]()
    var feedGroup = [FeedGroup]()
    var feedProfile = [FeedProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vkService = VKService()
        vkService.getNewsfeed(token: token!, completion: { response in
            //self.loadData()
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.allFeed = response
                strongSelf.tableView?.reloadData()
            }
        })
        vkService.findNewsfeedGroups(token: token!, completion: { response in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.feedGroup = response
                strongSelf.tableView?.reloadData()
            }
        })
        vkService.findNewsfeedProfiles(token: token!, completion: { response in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.feedProfile = response
                strongSelf.tableView?.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFeed.count
    }
    
    func getCellDateText(forIndexPath indexPath: IndexPath, andTimestamp timestamp: Double) -> String {
        var dateFormatter: DateFormatter {
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss"
            return df
        }
        var dateTextCache: [IndexPath : String] = [:]
        if let strDate = dateTextCache[indexPath] {
            return strDate
        } else {
            let date = Date(timeIntervalSince1970: timestamp)
            let strDate = dateFormatter.string(from: date)
            dateTextCache[indexPath] = strDate
            return strDate
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFeedCell", for: indexPath) as! MyFeedCell
        let feed = allFeed[indexPath.row]

        /*
        let unixTimestamp = feed.date
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: date)
        */
        
        cell.postDate.text = getCellDateText(forIndexPath: indexPath, andTimestamp: Double(feed.date))
        
        
        cell.postText.text = feed.text
        //cell.postDate.text = strDate
        
        for group in feedGroup {
            if feed.sourceId == -group.id {
                cell.authorName.text = group.groupName
                let urlImage = URL(string: group.photo100)
                cell.authorLogo.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))
            }
        }
        for profile in feedProfile {
            if feed.sourceId == profile.id {
                cell.authorName.text = profile.firstName + " " + profile.lastName
                let urlImage = URL(string: profile.photo100)
                cell.authorLogo.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))
            }
        }
        cell.likes.text = "Likes - " + String(feed.likes)
        cell.reposts.text = "Reposts - " + String(feed.reposts)
        
//        if feed.newsType == "post" {
//            for attachment in feed.attachments {
//                if feed.attachmentType == "photo" {
//                    let urlImage = URL(string: feed.photoUrl)
//                    cell.postImages.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))
//                }
//            }
//        }
//        if feed.newsType == "post" {
//            for attachment in feed.attachments {
//
//            }
//        }
print(feed.attachments)
        return cell
    }
    
    
}


class MyFeed: Object {
    var sourceId: Int = 0
    var date: Int = 0
    var postId: Int = 0
    var text = ""
    var likes: Int = 0
    var reposts: Int = 0
    var newsType: String = ""
//    var attachmentType: String = ""
//    var photoSize: String = ""
//    var photoUrl: String = ""
    var attachments: [AttachmentJson] = []
    convenience init(json: JSON) {
        self.init()
        self.sourceId = json["source_id"].intValue
        self.date = json["date"].intValue
        self.postId = json["post_id"].intValue
        self.text = json["text"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.newsType = json["type"].stringValue
//        self.attachmentType = json["attachments"]["type"].stringValue
//        self.photoSize = json["attachments"]["photo"]["sizes"]["type"].stringValue
//        self.photoUrl = json["attachments"]["photo"]["photo_130"].stringValue
        self.attachments = json["attachments"].map { AttachmentJson(json: $0.1)}
        //self.attachments.append(AttachmentJson(json: JSON))
    }
}
class AttachmentJson {
    var attachmentType: String = ""
    var photoSize: String = ""
    var photoUrl: String = ""
    init(json: JSON) {
        self.attachmentType = json["type"].stringValue
        self.photoSize = json["photo"]["sizes"]["type"].stringValue
        self.photoUrl = json["photo"]["photo_130"].stringValue
    }
}
class FeedGroup {
    var id: Int = 0
    var groupName: String = ""
    var photo100: String = ""
    init(json: JSON) {
        self.id = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
}
class FeedProfile {
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var photo100: String = ""
    init(json: JSON) {
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo100 = json["photo_100"].stringValue
    }
}
