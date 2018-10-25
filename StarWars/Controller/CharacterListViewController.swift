//
//  CharacterListViewController.swift
//  StarWars
//
//  Created by DetroitLabs on 10/24/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class CharacterListViewController: UITableViewController {

    var characterURLs: [String] = []
    var characterData: [CharacterData] = []
    var results: FilmData?
    let filmURL = "https://swapi.co/api/films/2/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = performRequest(with: urlForCall(from: filmURL)) {
            let parsed = parseFilmData(data: data)!
            characterURLs = parsed.characters
        }
        
        for url in characterURLs {
            if let data = performRequest(with: urlForCall(from: url)) {
                let parsed = parseCharacterData(data: data)
                characterData.append(parsed!)
            }
        }
        
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return characterData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)

        cell.textLabel?.text = characterData[indexPath.row].name

        return cell
    }
    
    func urlForCall(from string: String) -> URL {
        let url = URL(string: string)
        return url!
    }
    
    func performRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func parseFilmData(data: Data) -> FilmData? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(FilmData.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    func parseCharacterData(data: Data) -> CharacterData? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CharacterData.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail" {
            guard let detailView = segue.destination as? CharacterDetailViewController else { return }
            detailView.character = characterData[0]
        }
    }

}
