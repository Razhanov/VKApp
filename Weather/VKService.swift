//
//  VKService.swift
//  Weather
//
//  Created by Karim Razhanov on 07/05/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift


class VKService {
    
    let apiUrl = "https://api.vk.com"
    
    func getFriend(userId: String, token: String, completion: @escaping ([MyFriend]) -> Void ) {
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
        let path = "/method/friends.get"
        let parameters = [
            "user_id" : userId,
            "order" : "hints",
            "fields" : "nickname, photo_50",
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.vk.com"
//        urlComponents.path = "/method/friends.get"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "user_id", value: userId),
//            URLQueryItem(name: "order", value: "hints"),
//            URLQueryItem(name: "fields", value: "nickname"),
//            URLQueryItem(name: "access_token", value: token),
//            URLQueryItem(name: "v", value: "5.74")
//        ]
//        let request = URLRequest(url: urlComponents.url!)
        
//        let task =  session.dataTask(with: request) { (data, response, error) in
//            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//            print("")
//            print("getFriend")
//
////            print(json!)
//        }
//
//        task.resume()
//        print("Запрос getFriend - \(request)")
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.main) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let myFriend = json["response"]["items"].compactMap { MyFriend(json: $0.1)}
                self.saveFriendsData(myFriend)
                completion(myFriend)
            } catch {
                
            }
        }
    }
    
    func getGroupList(userId: String, token: String, completion: @escaping ([MyGroup]) -> Void) {
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
        
        let path = "/method/groups.get"
        let parameters = [
            "user_id" : userId,
            "extended" : "1",
            "fields" : "members_count",
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.main) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let groups = json["response"]["items"].compactMap { MyGroup(json: $0.1)}
                self.saveMyGroupsData(groups)
                completion(groups)
            } catch {
                
            }
        }
        
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.vk.com"
//        urlComponents.path = "/method/groups.get"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "user_id", value: userId),
//            URLQueryItem(name: "extended", value: "1"),
//            URLQueryItem(name: "fields", value: "members_count"),
//            URLQueryItem(name: "count", value: "10"),
//            URLQueryItem(name: "access_token", value: token),
//            URLQueryItem(name: "v", value: "5.74")
//        ]
//        let request = URLRequest(url: urlComponents.url!)
//
//        let task =  session.dataTask(with: request) { (data, response, error) in
//            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//            print("")
//            print("getGroupList")
////            print(json!)
//        }
//
//        task.resume()
//        print("Запрос getGroupList- \(request)")
        
        
    }
    
    func searchGroup(search: String, token: String, completion: @escaping ([AllGroups]) -> Void) {
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
        let path = "/method/groups.search"
        let parameters = [
            "q" : search,
            "sort" : "0",
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let groups = json["response"]["items"].compactMap { AllGroups(json: $0.1)}
                completion(groups)
            } catch {
                
            }
        }
        
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.vk.com"
//        urlComponents.path = "/method/groups.search"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "q", value: search),
//            URLQueryItem(name: "sort", value: "0"),
//            URLQueryItem(name: "access_token", value: token),
//            URLQueryItem(name: "v", value: "5.74")
//        ]
//        let request = URLRequest(url: urlComponents.url!)
//
//        let task =  session.dataTask(with: request) { (data, response, error) in
//            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//            print("")
//            print("searchGroup")
////            print(json!)
//        }
//
//        task.resume()
//        print("Запрос searchGroup - \(request)")
    }
    
    func getPhotos(ownerId: String, token: String, completion: @escaping ([ProfilePhotos]) -> Void) {
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
        
        let path = "/method/photos.getAll"
        let parameters = [
            "owner_id" : ownerId,
            "extended" : "1",
            "photo_sizes" : "0",
//            "count" : "10",
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.main) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let photos = json["response"]["items"].compactMap { ProfilePhotos(json: $0.1)}
                self.savePhotosData(photos)
                completion(photos)
            } catch {
                
            }
        }
    }
    
    func getNewsfeed(token: String, completion: @escaping ([MyFeed]) -> Void) {
   
        let path = "/method/newsfeed.get"
        let parameters = [
            "filters" : "post",
            "return_banned" : "0",
            //"source_ids" : sourceId,
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let feed = json["response"]["items"].compactMap { MyFeed(json: $0.1)}
                //self.savePhotosData(photos)
                completion(feed)
            } catch {
                
            }
        }
    }
    func findNewsfeedGroups(token: String, completion: @escaping ([FeedGroup]) -> Void) {
        
        let path = "/method/newsfeed.get"
        let parameters = [
            "filters" : "post",
            "return_banned" : "0",
            //"source_ids" : sourceId,
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let group = json["response"]["groups"].compactMap { FeedGroup(json: $0.1)}
                //print(json)
                completion(group)
            } catch {
                
            }
        }
    }
    
    func findNewsfeedProfiles(token: String, completion: @escaping ([FeedProfile]) -> Void) {
        
        let path = "/method/newsfeed.get"
        let parameters = [
            "filters" : "post",
            "return_banned" : "0",
            //"source_ids" : sourceId,
            "access_token" : token,
            "v" : "5.74"
        ]
        
        let url = apiUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: DispatchQueue.global()) { response in
            guard let data = response.value else { return }
            do {
                let json = try JSON(data: data)
                let group = json["response"]["profiles"].compactMap { FeedProfile(json: $0.1)}
                //print(json)
                completion(group)
            } catch {
                
            }
        }
    }
    
    func saveFriendsData(_ friends: [MyFriend]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
            print(realm.configuration.fileURL)
            let oldData = realm.objects(MyFriend.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(friends)
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    func saveMyGroupsData(_ groups: [MyGroup]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL)
            let oldData = realm.objects(MyGroup.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(groups)
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
    func savePhotosData(_ photos: [ProfilePhotos]) {
        do {
            let realm = try Realm()
            let oldData = realm.objects(ProfilePhotos.self)
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(photos)
            try realm.commitWrite()
        } catch let error {
            print(error)
        }
    }
    
}


class GetCacheImage​: Operation {
    private let cacheLifeTime: TimeInterval = 3600
    private static let pathName: String = {
        let pathName = "images"
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) { try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)}
        return pathName
    }()
    private lazy var filePath: String? = {
        guard let cachesDiretcory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let hasheName = String(describing: url.hashValue)
        return cachesDiretcory.appendingPathComponent(GetCacheImage​.pathName + "/" + hasheName).path
    }()
    private let url: String
    var outputImage: UIImage?
    init(url: String) {
        self.url = url
    }
    override func main() {
        guard filePath != nil && !isCancelled else {
            return
        }
        if getImageFromChache() { return }
        guard !isCancelled else { return}
        if !downloadImage() { return }
        guard !isCancelled else {
            return
        }
        saveImageToChache()
    }
    private func getImageFromChache() -> Bool {
        guard let fileName = filePath, let info = try? FileManager.default.attributesOfItem(atPath: fileName), let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return false }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        guard lifeTime <= cacheLifeTime, let image = UIImage(contentsOfFile: fileName) else { return false }
        self.outputImage = image
        return true
    }
    private  func downloadImage() -> Bool {
        guard let url = URL(string: url), let data = try? Data.init(contentsOf: url), let image = UIImage(data: data) else { return false }
        self.outputImage = image
        return true
    }
    private func saveImageToChache() {
        guard let fileName = filePath, let image = outputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
