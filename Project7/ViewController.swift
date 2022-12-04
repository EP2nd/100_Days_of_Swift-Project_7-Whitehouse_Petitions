//
//  ViewController.swift
//  Project7
//
//  Created by Edwin Przeźwiecki Jr. on 28/04/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    /// Challenge 2:
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Challenge 2:
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(promptForFiltration))
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector (resetPetitionsList))
        
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
        
        /// Challenge 1:
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(openTapped))
        
//      let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        
        /* let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
//          urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
//          urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        } */
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            /* DispatchQueue.main.async {
                self.tableView.reloadData()
            } */
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alertController, animated: true)
        }
    }
    
    /// Challenge 1:
    @objc func openTapped() {
        
        let alertController = UIAlertController(title: nil, message: "The data comes from the \"We The People\" API of the Whitehouse.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alertController, animated: true)
    }
    
    /// Challenge 2:
    @objc func promptForFiltration() {
        
        let alertController = UIAlertController(title: "Enter a keyword", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitKeyword = UIAlertAction(title: "Filter", style: .default) { [weak self, weak alertController] action in
            guard let keyword = alertController?.textFields?[0].text else { return }
            
            self?.filter(keyword)
        }
        
        alertController.addAction(submitKeyword)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alertController, animated: true)
    }
    
    /// Challenge 2:
    @objc func resetPetitionsList() {
        filteredPetitions = petitions
        
        tableView.reloadData()
    }
    
    /// Challenge 2:
    func filter(_ keyword: String) {
        /// Project 9, challenge 3:
        DispatchQueue.global().async {
            self.filteredPetitions.removeAll(keepingCapacity: true)
            
            for petition in self.petitions {
                if petition.title.lowercased().contains(keyword) {
                    self.filteredPetitions.append(petition)
                    
//                  self.tableView.reloadData()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let viewController = DetailViewController()
        
        viewController.detailItem = filteredPetitions[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

