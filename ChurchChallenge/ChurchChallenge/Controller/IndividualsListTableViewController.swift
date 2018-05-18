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
    var individualsList = [Individual]()
    var selectedIndividual = Individual()
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        do {
            let realm = try Realm()
            notificationToken = realm.observe { [unowned self] note, realm in
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to add realm observer")
        }
        refreshTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: Constants.ShowInfoAlert) == true || UserDefaults.standard.object(forKey: Constants.ShowInfoAlert) == nil {
            UserDefaults.standard.set(false, forKey: Constants.ShowInfoAlert)
            showAlert(title: "Need to refresh?", message: "If you need to refresh the data, just \"Pull to Refresh\". If anything is saved to disk, it will load that. Else it will fetch from the web.")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    @IBAction func pullToRefresh(_ sender: Any) {
        refreshTableData()
    }
    
    func refreshTableData() {
        individualsList.removeAll()
        if let list = getIndividualFromDisc() {
            for item in list {
                self.individualsList.append(item)
            }
            self.individualsList.sort { $0.id < $1.id }
            self.refreshControl?.endRefreshing()
            tableView.reloadData()
            guard list.isEmpty else {
                return
            }
        }
        fetchIndividuals { (individuals) in
            if let list = individuals {
                self.individualsList = list
            }
            self.individualsList.sort { $0.id < $1.id }
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func deleteIndividuals(_ sender: Any) {
        // Clean all individuals on disk.
        deleteAllIndividualOnDisc()
        individualsList.removeAll()
        tableView.reloadData()
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
        return 225
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IndividualTableViewCell, for: indexPath) as! IndividualTableViewCell
        cell.profileImage.image = nil
        let profile = individualsList[indexPath.row]
        
        if let picture = profile.image {
            DispatchQueue.main.async {
                cell.profileImage.image = UIImage(data: picture as Data)
            }
        } else {
            dowmloadImage(url: individualsList[indexPath.row].profilePicture!) { (returnImage: UIImage) in
                if !self.individualsList.isEmpty {
                    do {
                        let realm = try Realm()
                        try realm.write {
                            self.individualsList[indexPath.row].image = UIImagePNGRepresentation(returnImage) as NSData?
                        }
                    } catch {
                        print("Failed to save image to individual object")
                    }
                } else {
                    print("Missing index.")
                }
            }
        }
        
        cell.nameLabel.text = profile.fullname
        if let affiliation = profile.affiliation {
            cell.AffiliationImage.image = getAffiliationImage(affil: affiliation)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndividual = individualsList[indexPath.row]
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
