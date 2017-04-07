//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Egor Trefilov on 07/04/17.
//  Copyright © 2017 Egor Trefilov. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameTest: UILabel!
    
    var chosenPokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTest.text = chosenPokemon.name
    }
}
