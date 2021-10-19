//
//  ViewController.swift
//  5102 Swift Games
//
//  Created by Erik Taylor on 10/18/21.
//

import UIKit

class ViewController: UIViewController {
    var gameBoard : GameBoard?
    var user1 : User?
    var user2 : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    func createGame() {
        gameBoard = GameBoard()
        user1 = User(token: "X")
        user2 = User(token: "O")
    }
}
