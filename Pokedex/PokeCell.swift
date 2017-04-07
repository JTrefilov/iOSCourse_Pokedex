 //
//  PokeCell.swift
//  Pokedex
//
//  Created by Egor Trefilov on 07/04/17.
//  Copyright © 2017 Egor Trefilov. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //  Creating an instance of pokemon class
    var pokemon: Pokemon!
    
    
    //  Setting values for outlets
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        
        nameLabel.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexID)")
    }
    
    //  Changing corner radius
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
}
