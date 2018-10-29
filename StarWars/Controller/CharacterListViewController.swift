//
//  CharacterListViewController.swift
//  StarWars
//
//  Created by DetroitLabs on 10/24/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class CharacterListViewController: UITableViewController {

    // MARK: Properties

    private var characterURLs: [String] = []
    private var characterData: [CharacterData] = []
    private var results: FilmData?
    private let filmURL = "https://swapi.co/api/films/2/"
    private var isLoading = false
    var selectedIndex = 0

    // MARK: Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = true
        getCharacterURLData(from: filmURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        useLargeTitles()
    }

}

// MARK: TableView Methods

extension CharacterListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return characterData.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)

        if isLoading {
            cell.textLabel?.text = "Loading..."
        }
        else {
            cell.textLabel?.text = characterData[indexPath.row].name
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

// MARK: API Methods

extension CharacterListViewController {
    
    func urlForCall(from string: String) -> URL {
        let url = URL(string: string)
        return url!
    }
    
    func performRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            showNetworkError()
            return nil
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Error", message: "There was a problem accessing the Star Wars API. Please try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func getCharacterURLData(from urlString: String) {
        let url = urlForCall(from: urlString)
        let session = URLSession.shared

        let dataTask = session.dataTask(with: url) { (data, response, error) in

            if let error = error {
                self.showNetworkError()
                print("error: \(error)")
                return
            }

            guard let data = data else { return }
            let parsed = self.parseFilmData(data: data)!
            self.characterURLs = parsed.characters

            self.getCharacterData()
            self.correctCharacterDetails()

            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.reloadData()
            }

        }

        dataTask.resume()
    }

    func getCharacterData() {
        for url in characterURLs {
            if let data = performRequest(with: urlForCall(from: url)) {
                let parsed = parseCharacterData(data: data)
                characterData.append(parsed!)
            }
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

    func extractName(from data: Data) -> String? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(NameData.self, from: data)
            return result.name
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }

    func getCharacterDetailString(from urlString: String) -> String {
        let url = URL(string: urlString)!
        let data = performRequest(with: url)!
        return extractName(from: data)!
    }

    func correctCharacterDetails() {
        for character in characterData {
            character.homeworld = getCharacterDetailString(from: character.homeworld)
            character.species = [getCharacterDetailString(from: character.species[0])]
        }
    }

}

// MARK: Navigation

extension CharacterListViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail" {
            guard let detailView = segue.destination as? CharacterDetailViewController else { return }
            detailView.character = characterData[selectedIndex]
        }
    }

}
