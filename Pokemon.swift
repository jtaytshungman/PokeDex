//
//  Pokemon.swift
//  PokeDex
//
//  Created by Jeremy Tay on 05/09/2017.
//  Copyright © 2017 Jeremy Tay. All rights reserved.
//

import Foundation

class Pokemon {
    var url : String
    var name : String
    
    init(name : String, url : String) {
        self.name = name
        self.url = url 
    }
}
