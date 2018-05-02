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
var birthdate: String? //1963-05-05 ,
var profilePicture: String? //https://edge.ldscdn.org/mobile/interview/07.png ,
var forceSensitive: Bool?
var affiliation: Affiliation?
    var fullname: String {
        get { return "\(firstName ?? "") \(lastName ?? "")" }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, birthdate, profilePicture, forceSensitive, affiliation
    }
    
    func fetchIndividuals(doneStuffBlock: @escaping ([Individual]) -> Void) {
        let url = URL(string: "https://edge.ldscdn.org/mobile/interview/directory")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970 // It is necessary for correct decoding. Timestamp -> Date.

        Alamofire.request(url).responseDecodableObject(keyPath: "individuals", decoder: decoder) { (response: DataResponse<[Individual]>) in
            if let error = response.result.error {
                print(error)
                return
            }
            
            
            let repo = response.result.value
            
            print(repo)
            doneStuffBlock(repo!)
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
//                self.presentAlert(title: "Load Failed", message: error)
                print(error)
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
