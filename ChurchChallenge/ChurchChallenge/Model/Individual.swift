//
//  Individual.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 4/30/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import AlamofireImage

struct Individual: Decodable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var birthdate: String?
    var profilePicture: String?
    var forceSensitive: Bool?
    var affiliation: Affiliation?
    var fullname: String {
        get { return "\(firstName ?? "") \(lastName ?? "")" }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, birthdate, profilePicture, forceSensitive, affiliation
    }
    
    func fetchIndividuals(completion: @escaping ([Individual]?) -> Void) {
        let url = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(url).responseDecodableObject(keyPath: "individuals", decoder: decoder) { (response: DataResponse<[Individual]>) in
            if let error = response.result.error {
                showAlert(title: "Faild to Fetch Individuals", message: error.localizedDescription)
                return
            }
            completion(response.result.value)
        }
    }
    
    /// Download single image of the web.
    ///
    /// - Parameters:
    ///   - url: Location of image.
    ///   - imageView: Which uiimageView to load it into.
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
    
}


enum Affiliation: String, Decodable {
    case JEDI, RESISTANCE, SITH, FIRST_ORDER
}
