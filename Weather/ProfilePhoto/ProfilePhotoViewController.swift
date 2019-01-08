//
//  ProfilePhotoViewController.swift
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

class ProfilePhotoViewController: UICollectionViewController {
    var photos = [ProfilePhotos]()
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vkService = VKService()
        vkService.getPhotos(ownerId: idOwner!, token: token!, completion: { response in
            self.loadData()
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.photos = response
                strongSelf.collectionView?.reloadData()
            }
        })
    }
    
    var nToken: NotificationToken?
    
    func loadData(){
        do {
            let realm = try Realm()
            let photos = realm.objects(ProfilePhotos.self)
            self.nToken = photos.observe {[weak self] (changes: RealmCollectionChange) in
                switch changes {
                case .initial(let results):
                    self?.collectionView?.reloadData()
                case let .update(results, deletions, insertions, modifications):
                    self?.collectionView?.performBatchUpdates({
                        self?.collectionView?.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0)}))
                        self?.collectionView?.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                        self?.collectionView?.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0)}))
                    }, completion: nil)
                case .error(let error):
                    fatalError("\(error)")
                }
                print("Data is changed")
            }
            self.photos = Array(photos)
            self.collectionView?.reloadData()
        } catch {
            print(error)
        }
    }
    func load() {
        let stepCounter = StepCounter()
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(stepCounter)
            try realm.commitWrite()
        } catch {
            print(error)
        }
        nToken = stepCounter.observe { change in
            switch change {
            case .change(let properties):
                print(properties)
            case .error(let error):
                print("An error occurred \(error)")
            case .deleted:
                print("The object was deleted.")
            }
        }
        do {
            let realm = try Realm()
            realm.beginWrite()
            stepCounter.steps += 1
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    override func numberOfSections(in colectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotoCell", for: indexPath) as! ProfilePhotoCell
        //let photo = photos[IndexPath.row]
        let urlImage = URL(string: photos[indexPath.row].photo604)
//        let session = URLSession(configuration: .default)
//        let getImage = session.dataTask(with: urlImage!) { (data, response, error) in
//            let image = UIImage(data: data!)
//            DispatchQueue.main.async {
//                cell.profilePhoto.image = image
//            }
//        }
//        getImage.resume()
//        cell.profilePhoto.image = UIImage(named: "Me")
        cell.profilePhoto.sd_setImage(with: urlImage!, placeholderImage: UIImage(named: "placeholder"))
        //cell.photoText.text = photos[indexPath.row].text
        cell.setPhotoText(text: photos[indexPath.row].text)
        let getCacheImage = GetCacheImage​(url: photos[indexPath.row].photo604)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.profilePhoto.image = getCacheImage.outputImage
            }
        }
        queue.addOperation(getCacheImage)

        return cell
    }
}

class ProfilePhotos: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var albumId:Int = 0
    @objc dynamic var ownerId:Int = 0
    @objc dynamic var photo75 = ""
    @objc dynamic var photo130 = ""
    @objc dynamic var photo604 = ""
    @objc dynamic var photo807 = ""
    @objc dynamic var photo1280 = ""
    @objc dynamic var photo2560 = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var text = ""
    @objc dynamic var date: Int = 0
    var likes = List<Likes>()
    var reposts = List<Reposts>()
    //@objc dynamic var reposts: [Reposts] = []
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.albumId = json["album_id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.photo75 = json["photo_75"].stringValue
        self.photo130 = json["photo_130"].stringValue
        self.photo604 = json["photo_604"].stringValue
        self.photo807 = json["photo_807"].stringValue
        self.photo1280 = json["photo_1280"].stringValue
        self.photo2560 = json["photo_2560"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.text = json["text"].stringValue
        self.date = json["date"].intValue
        json["likes"].map {  self.likes.append(Likes(json: $0.1))}
        json["reposts"].map { self.reposts.append(Reposts(json: $0.1))}
        //self.likes.append(Likes(json: JSON))
        //self.reposts = json["reposts"].map { Reposts(json: $0.1)}
    }
}

class StepCounter: Object {
    @objc dynamic var steps = 0
}

class Likes: Object {
    @objc dynamic var userLikes: Int = 0
    @objc dynamic var likes: Int = 0
    convenience init(json: JSON) {
        self.init()
        self.userLikes = json["user_likes"].intValue
        self.likes = json["count"].intValue
    }
}
class Reposts: Object {
    @objc dynamic var reposts: Int = 0
    convenience init(json: JSON) {
        self.init()
        self.reposts = json["count"].intValue
    }
}
