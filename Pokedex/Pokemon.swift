//
//  Pokemon.swift
//  Pokedex
//
//  Created by Egor Trefilov on 07/04/17.
//  Copyright © 2017 Egor Trefilov. All rights reserved.
//

import Foundation

class Pokemon{
    
    private var _name: String!
    private var _pokedexID: Int!
    
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    
    // These are our getters
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    //  Initializing name and ID variables. Initializer is needed when creating an instance of Pokemon class, this way we can see which values need to be passed in for the object to be created, and what format they have to be.
    
    init(name: String, pokedexID:Int){
        self._name = name
        self._pokedexID = pokedexID
    }
}
