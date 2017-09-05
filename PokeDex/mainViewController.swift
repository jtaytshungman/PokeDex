//
//  mainViewController.swift
//  PokeDex
//
//  Created by Jeremy Tay on 05/09/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        
    }
    
    func fetchData() {
        // send API requst
        
        // get the url first
        let urlString = "https://pokeapi.co/api/v2/pokemon/?limit=200"
        guard let url = URL(string: urlString) else {
            return print("URL not working")
        }
        
        // url session
        let session = URLSession.shared
        
        // create a URL task
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                print("DataTask Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data
                else {
                    print("Invalid Data")
                    return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []), let validJson = json as? [String : Any]
                else {
                    return
            }
            
            guard let pokemonArray = validJson ["results"] as? [[String : Any]] else {
                return
            }
            
            for pokemonData in pokemonArray {
                if let url = pokemonData["url"] as? String,
                    let name = pokemonData["name"] as? String{
                    let newPokemon = Pokemon(name: name, url: url)
                    self.pokemons.append(newPokemon)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        // task.resume must be outside of the task
        task.resume()
    }
}

extension mainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // move to the next view
        guard let targetVC = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? detailsViewController else {
            return
        }
        
        // setup
        targetVC.selectedPokemon = pokemons[indexPath.row]
        
        navigationController?.pushViewController(targetVC, animated: true)
    }
}

extension mainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // set up the cell name
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.detailTextLabel?.text = pokemons[indexPath.row].name
        
        return cell
    }
}
