//
//  detailsViewController.swift
//  PokeDex
//
//  Created by Jeremy Tay on 05/09/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit

class detailsViewController: UIViewController {

    var selectedPokemon : Pokemon?
    
    // pokemon image outlet
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    // pokemon details label
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pokemon = selectedPokemon {
            fetchPokemonDeatils(pokemon: pokemon)
        }
        
    }

    func fetchPokemonDeatils (pokemon : Pokemon?) {
        nameLabel.text = pokemon?.name
        
        // 1. URL
        guard let url = URL(string: pokemon!.url) else {
            return
        }
        
        // 2. Section
        let session = URLSession.shared
        
        // 3. Task
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard
                let data = data,
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonDict = jsonData as? [String : Any]
                else {
                    print("Invalid JSON")
                    return
            }
            
            if let weight = jsonDict["weight"] as? Int {
                DispatchQueue.main.async {
                    self.weightLabel.text = "\(weight)"
                }
            }
            
            if let height = jsonDict["height"] as? Int {
                DispatchQueue.main.async {
                    self.heightLabel.text = "\(height)"
                }
            }
            
            if let typesDict = jsonDict["types"] as? [[String : Any]] {
                
                var types : [String] = []
    
                for typeDict in typesDict {
                    if let type = typeDict["type"] as? [String : Any],
                        let typeName  = type["name"] as? String {
                        types.append(typeName)
                    }
                }
                
                DispatchQueue.main.async {
                    self.typeLabel.text = types.joined(separator: " : ")
                }
            }
            
            if let sprites = jsonDict["sprites"] as? [String : Any],
                let imageURL = sprites["front_default"] as? String {
                self.loadImage(from: imageURL)
            }
            
            if let abilityDict = jsonDict["abilities"] as? [[String : Any]] {
                var abilities : [String] = []
                
                for abilityDict in abilityDict {
                    if let ability = abilityDict["ability"] as? [String : Any], let abilityName = ability["name"] as? String {
                        abilities.append(abilityName)
                    }
                }
                
                DispatchQueue.main.async {
                    self.abilityLabel.text = abilities.joined(separator: " : ")
                }
            }
        }
        // 4. Start the task.resume()
        task.resume()
    }
    
    func loadImage (from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.pokemonImageView.image = UIImage(data: data)
                }
            }
        }
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
