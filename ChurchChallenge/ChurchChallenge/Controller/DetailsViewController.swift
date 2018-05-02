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
    
    var individual = Individual()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.image = image
        nameLabel.text = individual.fullname
        idLabel.text = "\(individual.id ?? 0)"
        affiliationLabel.text = individual.affiliation?.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
