//
//  Profile.swift
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

class Profile: Object, Decodable {
    @objc dynamic var image: NSData?
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var birthdate: String?
    @objc dynamic var profilePicture: String?
    @objc dynamic var forceSensitive: Bool = false
    @objc dynamic var affiliation: String?
    var fullname: String {
        get { return "\(firstName ?? "") \(lastName ?? "")" }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, birthdate, profilePicture, forceSensitive, affiliation
    }
    
    func fetchIndividuals(completion: @escaping ([Profile]?) -> Void) {
        let url = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(url).responseDecodableObject(keyPath: "individuals", decoder: decoder) { (response: DataResponse<[Profile]>) in
            if let error = response.result.error {
                showAlert(title: "Faild to Fetch Individuals", message: error.localizedDescription)
                return
            }
            completion(response.result.value)
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
    func load() -> Results<Profile>? {
        do {
            let realm = try Realm()
            return realm.objects(Profile.self).sorted(byKeyPath: "firstName")
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
                realm.delete(realm.objects(Profile.self))
            }
        } catch {
            showAlert(title: "Delete All Failed", message: error.localizedDescription)
        }
    }
    
}


enum Affiliation: String, Decodable {
    case JEDI, RESISTANCE, SITH, FIRST_ORDER
}


