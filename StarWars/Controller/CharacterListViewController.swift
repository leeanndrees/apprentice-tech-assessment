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

    private func useLargeTitles() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

// MARK: API Methods

extension CharacterListViewController {
    
    private func urlForCall(from string: String) -> URL {
        let url = URL(string: string)
        return url!
    }
    
    private func performRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            showNetworkError()
            return nil
        }
    }
    
    private func showNetworkError() {
        let alert = UIAlertController(title: "Error", message: "There was a problem accessing the Star Wars API. Please try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func getCharacterURLData(from urlString: String) {
        let url = urlForCall(from: urlString)
        let session = URLSession.shared

        let dataTask = session.dataTask(with: url) { (data, response, error) in

            if let error = error {
                self.showNetworkError()
                print("error: \(error)")
                return
            }

            guard let data = data else { self.showNetworkError(); return }
            guard let parsed = self.parseFilmData(data: data) else { self.showNetworkError(); return }
            self.characterURLs = parsed.characters

            self.getCharacterData()
            self.getFilmNames()
            self.correctCharacterDetails()

            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.reloadData()
            }

        }

        dataTask.resume()
    }

    private func getCharacterData() {
        for url in characterURLs {
            if let data = performRequest(with: urlForCall(from: url)) {
                guard let parsed = parseData(data: data, targetType: CharacterData.self) else { return }
                characterData.append(parsed)
            }
        }
    }
    
    private func getFilmNames() {
        var filmNames : [String] = []
        
        for character in characterData {
            filmNames = []
            for url in character.films {
                guard let data = performRequest(with: urlForCall(from: url)) else { return }
                guard let filmName = extractTitle(from: data) else { return }
                filmNames.append(filmName)
            }
            character.films = filmNames
        }
    }

    private func parseFilmData(data: Data) -> FilmData? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(FilmData.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }

    private func parseCharacterData(data: Data) -> CharacterData? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CharacterData.self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    func parseData<T:Decodable>(data: Data, targetType: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(targetType, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }

    private func extractName(from data: Data) -> String? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(NameData.self, from: data)
            return result.name
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    private func extractTitle(from data: Data) -> String? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(FilmData.self, from: data)
            return result.title
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }

    private func getCharacterDetailString(from urlString: String) -> String? {
        guard let data = performRequest(with: urlForCall(from: urlString)) else { return nil }
        return extractName(from: data)
    }

    private func correctCharacterDetails() {
        for character in characterData {
            guard let newHomeWorld = getCharacterDetailString(from: character.homeworld) else { return }
            character.homeworld = newHomeWorld
            guard let newSpecies = getCharacterDetailString(from: character.species[0]) else { return }
            character.species = [newSpecies]
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
