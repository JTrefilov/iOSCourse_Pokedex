//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Egor Trefilov on 07/04/17.
//  Copyright © 2017 Egor Trefilov. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    var chosenPokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chosenPokemon.downloadPokemonDetails {
            // Updating label values
            self.updateUI()
        }
        
        nameLabel.text = chosenPokemon.name.capitalized
        pokedexIDLabel.text = "\(chosenPokemon.pokedexID)"
        mainImage.image = UIImage(named: "\(chosenPokemon.pokedexID)")
        currentEvoImage.image = mainImage.image 
    }
    
    //  This is how we assign the downloaded data to labels
    func updateUI(){
        descriptionLabel.text = chosenPokemon.description
        typeLabel.text = chosenPokemon.type
        defenseLabel.text = chosenPokemon.defense
        heightLabel.text = chosenPokemon.height
        weightLabel.text = chosenPokemon.weight
        attackLabel.text = chosenPokemon.attack
        
        if chosenPokemon.nextEvolutionName == "" {
            evoLabel.text = "This is the last evolution"
        } else{
            evoLabel.text = "Next Evolution: \(chosenPokemon.nextEvolutionName.capitalized) \(chosenPokemon.nextEvolutionLevel) LVL"
        }
        
        nextEvoImage.image = UIImage(named: "\(chosenPokemon.nextEvolutionID)")
    }
    
    
    //  Returning to main view controller
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
