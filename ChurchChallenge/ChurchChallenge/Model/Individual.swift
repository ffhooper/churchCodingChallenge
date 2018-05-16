//
//  Individual.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/2/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import CodableAlamofire
import AlamofireImage

class Individual: Object, Decodable {
    @objc dynamic var image: NSData?
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var birthdate: String?
    @objc dynamic var profilePicture: String? // This it the url from the image.
    @objc dynamic var forceSensitive: Bool = false
    @objc dynamic var affiliation: String?
    var fullname: String {
        get { return "\(firstName ?? "") \(lastName ?? "")" }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, birthdate, profilePicture, forceSensitive, affiliation
    }
    
    /// Load data for individuals from url.
    ///
    /// - Parameter completion: Array of Individuals from the url.
    func fetchIndividuals(completion: @escaping ([Individual]?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(url).responseDecodableObject(keyPath: "individuals", decoder: decoder) { (response: DataResponse<[Individual]>) in
            if let error = response.result.error {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                showAlert(title: "Failed to Fetch Individuals", message: error.localizedDescription)
                return
            }
            if let list = response.result.value {
                for item in list {
                    // Load image for the individual.
                    if let url = item.profilePicture {
                        item.dowmloadImage(url: url) { (returnImage: UIImage) in
                            if let data = UIImagePNGRepresentation(returnImage) as NSData? {
                                item.image = data
                                IndividualsListTableViewController.numberOfImagesLoaded += 1
                                print(url)
                                if IndividualsListTableViewController.numberOfImagesLoaded == list.count {
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    completion(list)
                                }
                            }
                        }
                    }
                }
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(response.result.value)
            }
        }
    }
    
    /// Download single image from the web.
    ///
    /// - Parameters:
    ///   - url: Location of image.
    ///   - returnImage: UIImage returned back.
    func dowmloadImage(url: String, returnImage: @escaping (UIImage) -> Void) {
        Alamofire.request(url).responseImage { response in
            if let error = response.error?.localizedDescription {
                showAlert(title: "Load Failed", message: error)
            }
            if let image = response.result.value {
                returnImage(image)
            }
        }
    }
    
    
    
    // Save to disk with Realm.
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch {
            showAlert(title: "Save Failed", message: error.localizedDescription)
        }
    }
    
    // Load from disk with Realm.
    func load() -> Results<Individual>? {
        do {
            let realm = try Realm()
            return realm.objects(Individual.self).sorted(byKeyPath: "id")
        } catch {
            showAlert(title: "Load Failed", message: error.localizedDescription)
            return nil
        }
    }
    
    // Delete all from disk with Realm.
    func deleteAll() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(Individual.self))
            }
        } catch {
            showAlert(title: "Delete All Failed", message: error.localizedDescription)
        }
    }
    
}




