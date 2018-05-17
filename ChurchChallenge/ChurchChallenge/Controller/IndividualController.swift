//
//  IndividualController.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/17/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire
import CodableAlamofire
import AlamofireImage

/// Load data for individuals from url and save to disc.
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
                let person = Individual()
                person.id = item.id
                if let firstName = item.firstName {
                    person.firstName = firstName
                }
                if let lastName = item.lastName {
                    person.lastName = lastName
                }
                if let birthdate = item.birthdate {
                    person.birthdate = birthdate
                }
                if let profilePicture = item.profilePicture {
                    person.profilePicture = profilePicture
                }
                person.forceSensitive = item.forceSensitive
                person.affiliation = item.affiliation
                
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(person)
                    }
                } catch {
                    showAlert(title: "Save Failed", message: error.localizedDescription)
                }
            }
            completion(list)
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion(response.result.value)
        }
    }
}

// Load from disk with Realm.
func getIndividualFromDisc() -> Results<Individual>? {
    do {
        let realm = try Realm()
        return realm.objects(Individual.self).sorted(byKeyPath: "id")
    } catch {
        showAlert(title: "Load Failed", message: error.localizedDescription)
        return nil
    }
}

// Delete all from disk with Realm.
func deleteAllIndividualOnDisc() {
    do {
        let realm = try Realm()
        try realm.write {
            realm.delete(realm.objects(Individual.self))
        }
    } catch {
        showAlert(title: "Delete All Failed", message: error.localizedDescription)
    }
}
