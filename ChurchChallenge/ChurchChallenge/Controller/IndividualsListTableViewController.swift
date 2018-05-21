//
//  IndividualsListTableViewController.swift
//  ChurchChallenge
//
//  Created by Riley Hooper on 4/30/18.
//  Copyright © 2018 Riley Hooper. All rights reserved.
//

import UIKit
import RealmSwift

class IndividualsListTableViewController: UITableViewController {
   static var individualsList = [Individual]()
    var selectedIndividual = Individual()
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        // listen for realm to finish.
        do {
            let realm = try Realm()
            notificationToken = realm.observe { [unowned self] note, realm in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("Failed to add realm observer: \(error.localizedDescription)")
        }
        
        refreshDataFromDisc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: Constants.ShowInfoAlert) == true || UserDefaults.standard.object(forKey: Constants.ShowInfoAlert) == nil {
            UserDefaults.standard.set(false, forKey: Constants.ShowInfoAlert)
            showAlert(title: "Need to refresh?", message: "If you need to refresh the data, just \"Pull to Refresh\". If anything is saved to disk, it will load that. Else it will fetch from the web.")
        }
    }
    
    @IBAction func pullToRefresh(_ sender: Any) {
        refreshDataFromWeb()
        self.refreshControl?.endRefreshing()
    }
    
    func refreshDataFromWeb() {
        IndividualsListTableViewController.individualsList.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        fetchIndividuals { (individuals) in
            if let list = individuals {
                IndividualsListTableViewController.individualsList = list
            }
            IndividualsListTableViewController.individualsList.sort { $0.id < $1.id }
        }
    }
    
    func refreshDataFromDisc() {
        if IndividualsListTableViewController.individualsList.isEmpty {
            IndividualsListTableViewController.individualsList = getIndividualsFromDisc()?.map({ $0 }) ?? []
        }
    }
    
    @IBAction func deleteIndividuals(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Clean all individuals on disk.
        deleteAllIndividualsOnDisc()
        IndividualsListTableViewController.individualsList.removeAll()
        DispatchQueue.main.async {
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
        return IndividualsListTableViewController.individualsList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IndividualTableViewCell, for: indexPath) as! IndividualTableViewCell
        cell.profileImage.image = nil
        print(indexPath.row)
        let individual = IndividualsListTableViewController.individualsList[indexPath.row]
        cell.nameLabel.text = individual.fullname
        if let affiliation = individual.affiliation {
            cell.AffiliationImage.image = getAffiliationImage(affil: affiliation)
        }
        if let picture = individual.image {
            cell.profileImage.image = UIImage(data: picture as Data)
        } else {
            if let url = individual.profilePicture {
                dowmloadImage(person: individual, url: url, index: indexPath.row) { (returnImage: UIImage) in
                    do {
                        let realm = try Realm()
                        try realm.write {
                            IndividualsListTableViewController.individualsList[indexPath.row].image = UIImagePNGRepresentation(returnImage) as NSData?
                        }
                    } catch {
                        print("Failed to set image to individual object in array: \(error.localizedDescription)")
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndividual = IndividualsListTableViewController.individualsList[indexPath.row]
        performSegue(withIdentifier: Constants.toDetails, sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toDetails {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.individual = selectedIndividual
        }
    }
    
}
