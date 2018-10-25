//
//  CharacterDetailViewController.swift
//  StarWars
//
//  Created by DetroitLabs on 10/25/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UITableViewController {
    
    var character: CharacterData?
    var characterDetails: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        populateDetailsArray()
        tableView.reloadData()
    }
    
    func populateDetailsArray() {
        if let characterInfo = character {
            characterDetails.append(characterInfo.name)
            characterDetails.append(characterInfo.birth_year)
            characterDetails.append(characterInfo.gender)
            characterDetails.append(getCharacterDetailString(from: characterInfo.homeworld))
            characterDetails.append(getCharacterDetailString(from: characterInfo.species[0]))
        }
    }
    
    func performRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download error: \(error.localizedDescription)")
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
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return characterDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        cell.textLabel?.text = characterDetails[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
