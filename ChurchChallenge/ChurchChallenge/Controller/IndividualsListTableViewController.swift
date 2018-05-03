//
//  IndividualsListTableViewController.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 4/30/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import UIKit

class IndividualsListTableViewController: UITableViewController {
    var individualsList = [Individual]()
    var selectedIndividual = Individual()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        let ind = Individual()
        ind.fetchIndividuals { (individuals) in
            if let list = individuals {
                self.individualsList = list
            }
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Table view data source

extension IndividualsListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return individualsList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualTableViewCell", for: indexPath) as! IndividualTableViewCell
        
        let ind = Individual()
        ind.dowmloadImage(url: individualsList[indexPath.row].profilePicture!) { (returnImage: UIImage) in
            cell.profileImage.image = returnImage
        }
        
        cell.nameLabel.text = individualsList[indexPath.row].fullname
        
        switch individualsList[indexPath.row].affiliation?.rawValue {
        case Affiliation.JEDI.rawValue:
            cell.nameLabel.backgroundColor = UIColor.blue
        default:
            cell.nameLabel.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualTableViewCell", for: indexPath) as! IndividualTableViewCell
        if let image = cell.profileImage.image {
            selectedImage = image
        }
        selectedIndividual = individualsList[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let desinationVC = segue.destination as! DetailsViewController
            desinationVC.individual = selectedIndividual
            desinationVC.image = selectedImage
        }
     }
    
    
}
