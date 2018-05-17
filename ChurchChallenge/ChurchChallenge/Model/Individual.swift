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
    
}




