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
                        realm.add(person, update: true)
                    }
                } catch {
                    showAlert(title: "Save Failed", message: error.localizedDescription)
                }
            }
            completion(list)
        } else {
            completion(response.result.value)
        }
    }
}

/// Download single image from the web.
///
/// - Parameters:
///   - url: Location of image.
///   - returnImage: UIImage returned back.
func dowmloadImage(person: Individual, url: String, returnImage: @escaping (UIImage) -> Void) {
    print("dowmloadImage called")
    Alamofire.request(url).responseImage { response in
        if let error = response.error?.localizedDescription {
            showAlert(title: "Load Failed", message: error)
        }
        if let image = response.result.value {
            do {
                let realm = try Realm()
                try realm.write {
                    if !person.isInvalidated {
                        person.image = UIImagePNGRepresentation(image) as NSData?
                        realm.add(person, update: true)
                    }
                }
            } catch {
                print("Failed to save image to individual object: \(error.localizedDescription)")
            }
            returnImage(image)
        }
    }
}

// Load from disk with Realm.
func getIndividualsFromDisc() -> Results<Individual>? {
    do {
        let realm = try Realm()
        return realm.objects(Individual.self).sorted(byKeyPath: "id")
    } catch {
        showAlert(title: "Load Failed", message: error.localizedDescription)
        return nil
    }
}

// Delete all from disk with Realm.
func deleteAllIndividualsOnDisc() {
    do {
        let realm = try Realm()
        try realm.write {
            realm.delete(realm.objects(Individual.self))
        }
    } catch {
        showAlert(title: "Delete All Failed", message: error.localizedDescription)
    }
}
