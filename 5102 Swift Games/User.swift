//
//  User.swift
//  5102 Swift Games
//
//  Created by Carlos Del Carpio on 10/18/21.
//

import Foundation

class User {
    var identifier : String?
    var token : String?
    
    init (token : String) {
        self.token = token
    }
}
