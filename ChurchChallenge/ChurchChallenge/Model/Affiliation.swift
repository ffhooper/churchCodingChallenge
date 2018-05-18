//
//  Affiliation.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/15/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import UIKit

public enum Affiliation: String, Decodable {
    case JEDI, RESISTANCE, SITH, FIRST_ORDER
}

public func getAffiliationImage(affil: String) -> UIImage? {
    switch affil {
    case Affiliation.JEDI.rawValue:
        return UIImage(named: Constants.JediOrder)
    case Affiliation.RESISTANCE.rawValue:
        return UIImage(named: Constants.RebelAlliance)
    case Affiliation.SITH.rawValue:
        return UIImage(named: Constants.Sith)
    case Affiliation.FIRST_ORDER.rawValue:
        return UIImage(named: Constants.FirstOrder)
    default:
        return nil
    }
}
