//
//  GameBoard.swift
//  5102 Swift Games
//
//  Created by Carlos Del Carpio on 10/18/21.
//

import Foundation
import UIKit

class GameBoard: UIViewController {
    
    //Leaving as enum for now, can change to int or bool later if we want
    enum playerTurn{
        case X
        case O
    }
    
    //Will start game as X for now, let player choose later?
    var firstMove = playerTurn.X
    var currentMove = playerTurn.X
    var grid = [UIButton]()
    
    //Will use strings to set symbols on grid for now, can use images later if we want
    var x = "X"
    var o = "O"
    
    
    //Initialize Buttons for Grid
    @IBOutlet weak var topLeft_Btn: UIButton!
    @IBOutlet weak var topMiddle_Btn: UIButton!
    @IBOutlet weak var topRight_Btn: UIButton!

    @IBOutlet weak var middleLeft_Btn: UIButton!
    @IBOutlet weak var center_Btn: UIButton!
    @IBOutlet weak var middleRight_Btn: UIButton!
    
    @IBOutlet weak var bottomLeft_Btn: UIButton!
    @IBOutlet weak var bottomMiddle_Btn: UIButton!
    @IBOutlet weak var bottomRight_Btn: UIButton!
    
    @IBOutlet weak var move_Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGrid()
    }
    
    func initGrid(){
        grid.append(topLeft_Btn)
        grid.append(topMiddle_Btn)
        grid.append(topRight_Btn)
        grid.append(middleLeft_Btn)
        grid.append(center_Btn)
        grid.append(middleRight_Btn)
        grid.append(bottomLeft_Btn)
        grid.append(bottomMiddle_Btn)
        grid.append(bottomRight_Btn)
        
        
    }
    
    //Action for when button on TTT grid is tapped
    @IBAction func gridTap(_ sender: UIButton) {
        addMoveToGrid(sender)
        
        if checkGrid(x){
            resultMessage(title: "X wins!")
        }
        else if checkGrid(o){
            resultMessage(title: "O wins!")
        }
        
        
        if isGridFull(){
            resultMessage(title: "Tie!")
        }
    }
    
    func checkGrid(_ symbol: String) -> Bool{
        //check horizontal row victories
        if checkSymbol(topLeft_Btn, symbol) && checkSymbol(topMiddle_Btn, symbol) && checkSymbol(topRight_Btn, symbol){
            return true
        }
        if checkSymbol(middleLeft_Btn, symbol) && checkSymbol(center_Btn, symbol) && checkSymbol(middleRight_Btn, symbol){
            return true
        }
        if checkSymbol(bottomLeft_Btn, symbol) && checkSymbol(bottomMiddle_Btn, symbol) && checkSymbol(bottomRight_Btn, symbol){
            return true
        }
        
        //check vertical row victories
        if checkSymbol(topLeft_Btn, symbol) && checkSymbol(middleLeft_Btn, symbol) && checkSymbol(bottomLeft_Btn, symbol){
            return true
        }
        if checkSymbol(topMiddle_Btn, symbol) && checkSymbol(center_Btn, symbol) && checkSymbol(bottomMiddle_Btn, symbol){
            return true
        }
        if checkSymbol(topRight_Btn, symbol) && checkSymbol(middleRight_Btn, symbol) && checkSymbol(bottomRight_Btn, symbol){
            return true
        }
        
        //check diagnal victories
        if checkSymbol(topLeft_Btn, symbol) && checkSymbol(center_Btn, symbol) && checkSymbol(bottomRight_Btn, symbol){
            return true
        }
        if checkSymbol(topRight_Btn, symbol) && checkSymbol(center_Btn, symbol) && checkSymbol(bottomLeft_Btn, symbol){
            return true
        }
        
        return false
    }
    
    func checkSymbol(_ button: UIButton, _ symbol: String) -> Bool{
        return button.title(for: .normal) == symbol
    }
    
    //Add a symbol to the grid depending on whose turn it is (placement occurs automatically)
    func addMoveToGrid(_ sender: UIButton){
        //First check if button has no sybmol by checking it's title
        if (sender.title(for: .normal) == nil) || (sender.title(for: .normal) == ""){
            //button is empty, check whose turn it is and add symbol based on result
            if (currentMove == playerTurn.X){
                sender.setTitle(x, for: .normal)
                move_Label.text = "Player 2's Turn"
                currentMove = playerTurn.O
            }
            else if (currentMove == playerTurn.O){
                sender.setTitle(o, for: .normal)
                move_Label.text = "Player 1's Turn"
                currentMove = playerTurn.X
            }
            sender.isEnabled = false
            
        }
        
    }
    
    //Check if all slots on grid have been played
    func isGridFull() -> Bool{
        for slot in grid{
            if slot.title(for: .normal) == nil || slot.title(for: .normal) == ""{
                //Slot has not been played, grid is not full
                return false
            }
        }
        return true
    }
    
    //Present message to player
    func resultMessage(title: String){
        let message = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        message.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (_) in
            self.resetGrid()
        }))
        self.present(message, animated: true)
    }
    
    //Reset all slots in grid to blank and reset first move
    func resetGrid(){
        for slot in grid{
            slot.setTitle("", for: .normal)
            slot.isEnabled = true
        }
        if (firstMove == playerTurn.X){
            firstMove = playerTurn.X
            move_Label.text = "Player 1's Turn"
        }
        else if (firstMove == playerTurn.O){
            firstMove = playerTurn.O
            move_Label.text = "Player 2's Turn"
        }
        currentMove = firstMove
    }
    
}
