//
//  Pokemon.swift
//  Pokedex
//
//  Created by Egor Trefilov on 07/04/17.
//  Copyright © 2017 Egor Trefilov. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    private var _pokedexID: Int!
    
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    // These are our getters
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    //  More getters for values we cannot guarantee
    
    var description: String {
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil{
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    //  Initializing name and ID variables. Initializer is needed when creating an instance of Pokemon class, this way we can see which values need to be passed in for the object to be created, and what format they have to be.
    
    init(name: String, pokedexID:Int){
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(URL_BASE)\(self.pokedexID)/"
    }
    
    
    //  The function is called in the Details VC
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                
                // There can be several types for one pokemon, we check if we have at least one, then checking if we have more than one, and if so - use a loop to go throguh them one by one adding to description field
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0{
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    // Handling cases when there is more than one type
                    if types.count > 1{
                        for x in 1..<types.count{
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                
                
                // To get description we have to extract a new API link from descriptions field and call it
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>] , descriptions.count > 0{
                    if let descURL = descriptions[0]["resource_uri"]{
                        
                        print("Here are our checks:")
                        print("http://pokeapi.co\(descURL)")
                        
                        // Now we are calling for a new link that is stored in pokemon API
                        Alamofire.request("http://pokeapi.co\(descURL)").responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                if let descr = descDict["description"] as? String{
                                    
                                    // Changing POKMON to Pokemon in desription
                                    let descrAdj = descr.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = descrAdj
                                }
                            }
                            completed() // NB. Any time you are making a call - you need a completed() after it
                        })
                    }
                } else {
                    self._description = ""
                }
                
                // To get next evolution details we need to extract three proprties: Name, ID and Level
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    if let nextEvoName = evolutions[0]["to"] as? String{
                        
                        // To ignore evolution to mega pokemons that we have deleted
                        if nextEvoName.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvoName
                            
                            if let nextEvoURL = evolutions[0]["resource_uri"] as? String{
                                
                                let nextEvoURLAdj = nextEvoURL.replacingOccurrences(of: "api/v1/pokemon/", with: "")
                                let nextEvoID = nextEvoURLAdj.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionID = nextEvoID
                                
                                // for the level we check first if it exists and only then assign it
                                if let levelExist = evolutions[0]["level"]{
                                    if let level = levelExist as? Int{
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
