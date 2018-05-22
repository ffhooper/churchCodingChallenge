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
        
        // listen for realm to finish.
        notificationToken = getIndividualsFromDisc()?.observe { [weak self] changes in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.refreshDataFromDisc()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        refreshDataFromDisc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: Constants.ShowInfoAlert) == true || UserDefaults.standard.object(forKey: Constants.ShowInfoAlert) == nil {
            UserDefaults.standard.set(false, forKey: Constants.ShowInfoAlert)
            showAlert(title: "Need to refresh?", message: "If you need to refresh the data, just \"Pull to Refresh\". This will fetch from the web. And update anything saved on disk.")
        }
    }
    
    @IBAction func pullToRefresh(_ sender: Any) {
        refreshDataFromWeb()
        self.refreshControl?.endRefreshing()
    }
    
    func refreshDataFromWeb() {
        individualsList.removeAll()
        // Needed to prevent a crash
        tableView.reloadData()
        fetchIndividuals()
    }
    
    func refreshDataFromDisc() {
        individualsList = getIndividualsFromDisc()?.map({ $0 }) ?? []
    }
    
    @IBAction func deleteIndividuals(_ sender: Any) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Clean all individuals on disk.
        deleteAllIndividualsOnDisc()
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
        let individual = individualsList[indexPath.row]
        cell.nameLabel.text = individual.fullname
        if let affiliation = individual.affiliation {
            cell.AffiliationImage.image = getAffiliationImage(affil: affiliation)
        }
        if let picture = individual.image {
            cell.profileImage.image = UIImage(data: picture as Data)
        } else {
            if let url = individual.profilePicture {
                dowmloadImage(person: individual, url: url)
            }
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
