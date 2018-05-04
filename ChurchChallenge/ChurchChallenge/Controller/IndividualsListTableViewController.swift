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
    var images = [UIImage]()
    var savePeople = [Profile]()
    var selectedIndividual = Individual()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        if let list = Profile().load() {
            for item in list {
                self.savePeople.append(item)
            }
            tableView.reloadData()
            guard list.isEmpty else {
                return
            }
        }
            let ind = Individual()
            ind.fetchIndividuals { (individuals) in
                if let list = individuals {
                    self.individualsList = list
                }
                self.tableView.reloadData()
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        for per in savePeople {
        //            per.save()
        //        }
    }
    
    @IBAction func saveToDisk(_ sender: UIBarButtonItem) {
        ////////
        for rec in individualsList {
            let person = Profile()
            if let id = rec.id {
                person.id = id
            }
            if let firstName = rec.firstName {
                person.firstName = firstName
            }
            if let lastName = rec.lastName {
                person.lastName = lastName
            }
            if let birthdate = rec.birthdate {
                person.birthdate = birthdate
            }
            if let profilePicture = rec.profilePicture {
                person.profilePicture = profilePicture
            }
            if let forceSensitive = rec.forceSensitive {
                person.forceSensitive = forceSensitive
            }
            if let affiliation = rec.affiliation?.rawValue {
                person.affiliation = affiliation
            }
            
            let ind = Individual()
            if let urlString = rec.profilePicture {
                ind.dowmloadImage(url: urlString) { (returnImage: UIImage) in
                    if let data = UIImagePNGRepresentation(returnImage) as NSData? {
                        person.image = data
                        person.save()
                    }
                }
            }
        }
        /////////
    }
    
    
}

// MARK: - Table view data source

extension IndividualsListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savePeople.isEmpty {
            return individualsList.count
        } else {
            return savePeople.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualTableViewCell", for: indexPath) as! IndividualTableViewCell
        if savePeople.isEmpty {
            let profile = individualsList[indexPath.row]
            
            let ind = Individual()
            ind.dowmloadImage(url: individualsList[indexPath.row].profilePicture!) { (returnImage: UIImage) in
                cell.profileImage.image = returnImage
            }
            
            cell.nameLabel.text = profile.fullname
            switch profile.affiliation?.rawValue {
            case Affiliation.JEDI.rawValue:
                cell.nameLabel.backgroundColor = UIColor.blue
            default:
                cell.nameLabel.backgroundColor = UIColor.clear
            }
            return cell
        } else {
            let profile = savePeople[indexPath.row]
            
            if let picture = profile.image {
                cell.profileImage.image = UIImage(data: picture as Data)
            } else {
                let ind = Individual()
                ind.dowmloadImage(url: individualsList[indexPath.row].profilePicture!) { (returnImage: UIImage) in
                    cell.profileImage.image = returnImage
                }
            }
            
            cell.nameLabel.text = profile.fullname //individualsList[indexPath.row].fullname
            switch profile.affiliation {
            case Affiliation.JEDI.rawValue:
                cell.nameLabel.backgroundColor = UIColor.blue
            default:
                cell.nameLabel.backgroundColor = UIColor.clear
            }
            return cell
        }
        
        
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
