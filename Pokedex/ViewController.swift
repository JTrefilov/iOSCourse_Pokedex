//
//  ViewController.swift
//  Pokedex
//
//  Created by Egor Trefilov on 07/04/17.
//  Copyright © 2017 Egor Trefilov. All rights reserved.
//

import UIKit
import AVFoundation //to work with audio

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parsePokemonCSV()
        initAudio()
        
        
        // Needed for protocols to work
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done 
        
    }
    
    //  Functions necessary for Collection View protocols to work
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            //  Now we create a pokemon object that is different for every cell and use it to call a configureCell finction
            
            let addPokemon: Pokemon!
            
            //  Condition for whether we are in search mode. If there is smth in search box - we only show filtered values
            if inSearchMode{
                addPokemon = filteredPokemon[indexPath.row]
                cell.configureCell(addPokemon)
            } else {
                addPokemon = pokemon[indexPath.row]
                cell.configureCell(addPokemon)
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //  Seque to a detailed view
        var chosenPokemon: Pokemon!
        
        if inSearchMode{
            chosenPokemon = filteredPokemon[indexPath.row]
        } else {
            chosenPokemon = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: chosenPokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }

    
    //  Parsing pokemon csv data
    
    func parsePokemonCSV(){
        
        // Setting a path to our pokemon.csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            // Assigning csv file to a variable and selecting its rows (using csv.swift by Mark Price)
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            // Going thoguh rows to append pokemons array
            for row in rows{
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let newPoke = Pokemon(name: name, pokedexID: pokeID)
                
                pokemon.append(newPoke)
            }
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    //  Play music
    
    func initAudio(){
        
        //  Specifying path to a music file
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            // using path to populate the musicPlayer variable (created above)
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            
            // playing the music
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // will play forever
            musicPlayer.play()
            
            // handling errors (in case there is no music file)
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    // What do we do if the button is pressed
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2 // to make the button a bot transparent when it is pressed
            
        } else{
            musicPlayer.play()
            sender.alpha = 1.0
            
        }
    }
    
    // Search bar setting
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //  Preparing to send data to PokemonDetailVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC"{
            if let detailsVC = segue.destination as? PokemonDetailVC{
                if let chosenPokemon = sender as? Pokemon{
                    detailsVC.chosenPokemon = chosenPokemon
                }
            }
        }
    }
}
