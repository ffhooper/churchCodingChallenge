//
//  DetailsViewController.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/1/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var affiliationImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    
    var individual = Individual()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let picture = individual.image {
            profileImage.image = UIImage(data: picture as Data)
        }
        affiliationImage.image = individual.getAffiliationImage()
        nameLabel.text = individual.fullname
        idLabel.text = "\(individual.id)"
        dateOfBirthLabel.text = individual.birthdate
        forceSensitiveLabel.text = individual.forceSensitive ? "Yes" : "No"
        
        switch individual.affiliation {
        case Affiliation.JEDI.rawValue:
            affiliationLabel.text = "Jedi"
        case Affiliation.RESISTANCE.rawValue:
            affiliationLabel.text = "Resistance"
        case Affiliation.SITH.rawValue:
            affiliationLabel.text = "Sith"
        case Affiliation.FIRST_ORDER.rawValue:
            affiliationLabel.text = "First Order"
        default:
            affiliationLabel.text = "Missing"
        }
        
    }
    
}
