//
//  Individual.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 4/30/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import Foundation

struct Individual {
    

var id: Int?
var firstName: String?
var lastName: String?
var birthdate: Date? //1963-05-05 ,
var profilePicture: String? //https://edge.ldscdn.org/mobile/interview/07.png ,
var forceSensitive: Bool?
var affiliation: Affiliation?
}


enum Affiliation {
    case JEDI, RESISTANCE, SITH, FIRST_ORDER
}
