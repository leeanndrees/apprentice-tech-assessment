//
//  CharacterDetailViewController.swift
//  StarWars
//
//  Created by DetroitLabs on 10/25/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UITableViewController {
    
    // MARK: Properties
    
    var character: CharacterData?
    var characterDetails: [String] = []
    
    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        dontUseLargeTitles()
        populateDetailsArray()
        tableView.reloadData()
    }

}

// MARK: TableView Methods

extension CharacterDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return characterDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        cell.textLabel?.text = characterDetails[indexPath.row]
        
        return cell
    }
    
    func dontUseLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

// MARK: Private Implementation

extension CharacterDetailViewController {
    
    private func populateDetailsArray() {
        if let characterInfo = character {
            characterDetails.append(characterInfo.nameDescription)
            characterDetails.append(characterInfo.birthYearDescription)
            characterDetails.append(characterInfo.genderDescription)
            characterDetails.append(characterInfo.homeworldDescription)
            characterDetails.append(characterInfo.speciesDescription)
        }
    }
    
}
