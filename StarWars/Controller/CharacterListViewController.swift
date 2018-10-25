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
    var characterNames: [String] = []
    var results: FilmData?
    let filmURL = "https://swapi.co/api/films/2/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = performRequest(with: urlForCall(from: filmURL)) {
            let parsed = parseFilmData(data: data)!
            print("parsed: \(parsed)")
            characterURLs = parsed.characters
        }
        
        for url in characterURLs {
            if let data = performRequest(with: urlForCall(from: url)) {
                let parsed = parseCharacterData(data: data)
                let name = parsed?.name
                characterNames.append(name!)
            }
        }
        
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return characterNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)

        cell.textLabel?.text = characterNames[indexPath.row]

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
