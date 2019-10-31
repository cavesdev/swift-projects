//
//  ViewController.swift
//  Petitions
//
//  Created by Carlos C on 28/10/19.
//  Copyright © 2019 Carlos C. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    var filter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let creditButton = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        
        navigationItem.rightBarButtonItems = [creditButton, filterButton, reloadButton]
        
        reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        } else {
            showError()
        }
    }
    
    func showError() {
        let errorMessage = "There was an error loading. Please try again in a moment."
        let ac = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "We the people, API by the US gov", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        
        askForFilter()
        guard let filter = filter else { return }

        for petition in petitions {
            if petition.title.contains(filter) {
                filteredPetitions.append(petition)
            }
        }
        
        petitions = filteredPetitions
        tableView.reloadData()
    }
    
    func askForFilter() {
        let ac = UIAlertController(title: "Filter by", message: "Please insert a word.", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.filter = answer
        })
        present(ac, animated: true)
    }
    
    @objc func reloadData() {
        
        filter = nil
        filteredPetitions = [Petition]()
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetitionCell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

