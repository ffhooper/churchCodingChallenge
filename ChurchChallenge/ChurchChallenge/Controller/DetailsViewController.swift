//
//  DetailsViewController.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 5/1/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    
    var individual = Individual()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.image = image
        nameLabel.text = individual.fullname
        idLabel.text = "\(individual.id ?? 0)"
        affiliationLabel.text = individual.affiliation?.rawValue
        dateOfBirthLabel.text = individual.birthdate
        if let hasForce = individual.forceSensitive {
            forceSensitiveLabel.text = hasForce ? "Yes" : "No"
        }
        
    }

}
