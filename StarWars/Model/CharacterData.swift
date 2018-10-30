//
//  CharacterData.swift
//  StarWars
//
//  Created by DetroitLabs on 10/25/18.
//  Copyright © 2018 DetroitLabs. All rights reserved.
//

import Foundation

class CharacterData: Codable {
    
    var name = ""
    var mass = ""
    var birth_year = ""
    var gender = ""
    var homeworld = ""
    var films = [""]
    var species = [""]
    
    var nameDescription: String {
        return "Name: \(name)"
    }
    
    var massDescription: String {
        return "Mass: \(mass)kg"
    }
    
    var birthYearDescription: String {
        return "Birth Year: \(birth_year)"
    }
    
    var genderDescription: String {
        return "Gender: \(gender)"
    }
    
    var homeworldDescription: String {
        return "Homeworld: \(homeworld)"
    }
    
    var speciesDescription: String {
        return "Species: \(species[0])"
    }
}
