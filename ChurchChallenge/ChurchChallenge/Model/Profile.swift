//
//  Profile.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/2/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    func save() {
//        DispatchQueue.main.sync {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(self)
                }
            } catch {
                showAlert(title: "Save Failed", message: error.localizedDescription)
            }
//        }
    }
    
    func load() -> Results<Profile>? {
        do {
            let realm = try Realm()
            return realm.objects(Profile.self).sorted(byKeyPath: "firstName")
        } catch {
            showAlert(title: "Load Failed", message: error.localizedDescription)
            return nil
        }
    }
    
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
