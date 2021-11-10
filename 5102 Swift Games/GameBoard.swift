//
//  GameBoard.swift
//  5102 Swift Games
//
//  Created by Carlos Del Carpio on 10/18/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


//TODO: list
//  TODO: Single player - Let user play against themselves
//  TODO: Make other play wait till move has occured?
//  TODO: Better display to tell which player is which symbol / turn it is


class GameBoard: UIViewController, UITextFieldDelegate{
    //database holds the reference to the FireBase DB
    let database = Database.database().reference()
    
    var UserID: String?
    var UserEmail: String?

    var playerSymbol : String?
    var sessionID : String?
    
    var turnCount: Int? = 0 //Use this to determine whose move it is
    
    //Leaving as enum for now, can change to int or bool later if we want
    enum playerTurn{
        case X
        case O
    }
    
    //Will start game as X for now, let player choose later?
    var firstMove = playerTurn.X
    var currentMove = playerTurn.X
    
    var grid = [UIButton]()
    
    //Images
    let X_img : UIImage? = UIImage(named: "X_neon.png")
    let O_img : UIImage? = UIImage(named: "O_neon.png")
    let X_turn_img : UIImage? = UIImage(named: "p1_Turn.png")
    let O_turn_img : UIImage? = UIImage(named: "p2_Turn.png")
    let blank_img : UIImage? = UIImage(named: "blank.png")
    
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
    
    //Image to tell who goes next
    @IBOutlet weak var turn_img: UIImageView!
    
    @IBOutlet weak var opponentEmail: UITextField!
    
    //Tells game status
    @IBOutlet weak var gameInfo_Label: UILabel!
    
    
    
    //When the view first loads, create the grid and began listening for game invite
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.isModalInPresentation = true
        self.opponentEmail.delegate = self
        
        gameRequest()
        initGrid()
        
    }
    
    //Create grid
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
    
    //Action for when button on grid is tapped
    @IBAction func gridTap(_ sender: UIButton) {
        
        addMoveToGrid(sender)
        checkWinner()
        
    }
    
    //Checks if either player won and displays winner if found
    func checkWinner(){
        
        if checkGrid("X_neon"){
            resultMessage(title: "X wins!")
        }
        else if checkGrid("O_neon"){
            resultMessage(title: "O wins!")
        }
        
        if isGridFull(){
            resultMessage(title: "Tie!")
        }
        
    }
    
    //Checks each possible winning combination using whichever symbol is passed as param and returns true if a winner is found
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
    
    //Returns whether the image of a button = the symbol passed as param
    func checkSymbol(_ button: UIButton, _ symbol: String) -> Bool{
        
        return button.currentImage == UIImage(named: symbol)
        
    }
    
    //Add a symbol to the grid depending on whose turn it is (placement occurs automatically using sender)
    func addMoveToGrid(_ sender: UIButton){
        
        if isTurnAllowed(){
            //First check if button has no sybmol by checking it's title
            if (sender.title(for: .normal) == nil) || (sender.title(for: .normal) == ""){
                //button is empty, check whose turn it is and add symbol based on result and then switch turns
                
                if (playerSymbol == "X"){
                    sender.setImage(X_img, for: .normal)
                    turn_img.image = O_turn_img
                    currentMove = playerTurn.O
                }
                else if (playerSymbol == "O"){
                    sender.setImage(O_img, for: .normal)
                    turn_img.image = O_turn_img
                    currentMove = playerTurn.X
                }
                
                sender.isEnabled = false
                
            }
            
            //Check if user is playing someone else TODO: This doesn't do anything
            if (sessionID != nil){
                
                //Tell FireBase which button was pressed
                self.database.child("TicTacToe").child("OnlineSession").child(sessionID!).child("\(sender.accessibilityIdentifier ?? "")").setValue(formatEmail(email: UserEmail!))
                
            }
        }
        else{
            showMessage(title: "Wait!", message: "It's not your turn yet. Wait for your opponent's move...")
            return
        }
        
        

    }
    
    func isTurnAllowed() -> Bool{
        if (playerSymbol == "X"){
            //count needs to be 1, 3, 5, 7, 9
            if (turnCount! % 2 == 0){
                //Player X turn
                return true
            }
            else{
                return false
            }
        }
        if (playerSymbol == "O"){

            if (turnCount! % 2 == 0){
                //Player O turn
                return false
            }
            else{
                return true
            }
        }
        return true
    }
    
    //Check if all slots on grid have been played
    func isGridFull() -> Bool{
        
        for slot in grid{
            if slot.image(for: .normal) == nil || slot.image(for: .normal) == blank_img{
                return false
            }
        }
        
        return true
        
    }
    
    //Present message to player with game winner info and play again option
    func resultMessage(title: String){
        
        let message = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        message.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (_) in
            self.resetGrid()
        }))
        self.present(message, animated: true)
        
    }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Reset all slots in grid to blank and reset first move
    func resetGrid(){
       
        for slot in grid{
            slot.setImage(blank_img, for: UIControl.State.normal)
            slot.isEnabled = true
        }
        
        //TODO: This doesn't mean anything at the moment, need to work on turns
        if (firstMove == playerTurn.X){
            firstMove = playerTurn.X
            turn_img.image = O_turn_img
            
        }
        else if (firstMove == playerTurn.O){
            firstMove = playerTurn.O
            turn_img.image = X_turn_img
        }
        
        currentMove = firstMove
        turn_img.image = X_turn_img
        
        //Reset the FireBase values
        self.database.child("TicTacToe").child("OnlineSession").child(sessionID!).removeValue()
        
        turnCount = 0
        
    }
    
    //Listens for invite from other player. Fills opponent email text field with requesting player's email.
    func gameRequest(){
        
        self.database.child("TicTacToe").child("Users").child(formatEmail(email: UserEmail!)).child("Request").observe(.value, with: {
            (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshot{
                    
                    if let playerRequest = snap.value as? String{
                        
                        self.opponentEmail.text = playerRequest
                        self.database.child("TicTacToe").child("Users").child(self.formatEmail(email: self.UserEmail!)).child("Request").setValue(self.UserID)
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    //When invite button is tapped, initiate session between user and email of opponent and set symbols based on invite(X) vs accept(O)
    @IBAction func Invite_Button_Tap(_ sender: Any) {
        
        self.database.child("TicTacToe").child("Users").child(formatEmail(email:(opponentEmail.text)!)).child("Request").childByAutoId().setValue(UserEmail!)
        //If you invite someone, you become X
        playerSymbol = "X"
        createSession(sessionID: "\(formatEmail(email: UserEmail!)) \(formatEmail(email: opponentEmail.text!))")
        
    }
    
    //When the accept button is tapped, create a session with the opponent
    @IBAction func Accept_Button_Tap(_ sender: Any) {
        
        self.database.child("TicTacToe").child("Users").child(formatEmail(email:(opponentEmail.text)!)).child("Request").childByAutoId().setValue(UserEmail!)
        //If you accept an invite, you become O
        playerSymbol = "O"
        createSession(sessionID: "\(formatEmail(email: opponentEmail.text!)) \(formatEmail(email: UserEmail!))")
        
    }
    
    //This is where the game happens, this listens for an opponent's move and fills the board accordingly and checks for winners
    func createSession(sessionID: String){
        
        gameInfo_Label.text = ("Game Started!")
        
        if (playerSymbol == "X"){
            gameInfo_Label.text = "You are X!"
        }
        else{
            gameInfo_Label.text = "You are O!"
        }
        
        self.sessionID = sessionID
        self.database.child("TicTacToe").child("OnlineSession").child(sessionID).removeValue()
        self.database.child("TicTacToe").child("OnlineSession").child(sessionID).observe(.value, with: {
            
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.turnCount = 0
                for snap in snapshot{
                    
                    if let playerEmail = snap.value as? String{
                        
                        let keyGridPlacement = snap.key
                        if playerEmail == self.formatEmail(email: self.UserEmail!){
                            
                            //player's move
                            self.placeMove(gridLocation: keyGridPlacement, playerSymbol: self.playerSymbol!)
                            self.checkWinner()
                            
                        }
                        
                        else{
                            
                            //opponent's move
                            var opponentSymbol: String?
                            
                            if (self.playerSymbol == "X"){
                                
                                opponentSymbol = "O"
                                
                            }
                            
                            else{
                                
                                opponentSymbol = "X"
                            
                            }
                            self.placeMove(gridLocation: keyGridPlacement, playerSymbol: opponentSymbol!)
                            self.checkWinner()
                            
                        }
                        
                    }
                    self.turnCount! += 1 //Determines whose turn it is
                    
                }
                //count needs to be 1, 3, 5, 7, 9
                if (self.turnCount! % 2 == 0){
                    //Player X turn
                    self.turn_img.image = self.X_turn_img
                }
                else{
                    self.turn_img.image = self.O_turn_img
                }
                
            }
            
        })
        
    }
    
    //Function to dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //Based on the player's symbol, this will set the grid image for the slot selected
    func placeMove(gridLocation: String, playerSymbol: String){
        
        switch gridLocation{
            
        case "top_left":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                topLeft_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                topLeft_Btn.setImage(O_img, for: .normal)

            }
            
        case "top_middle":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                topMiddle_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                topMiddle_Btn.setImage(O_img, for: .normal)

            }
            
        case "top_right":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                topRight_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                topRight_Btn.setImage(O_img, for: .normal)

            }
            
        case "middle_left":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                middleLeft_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                middleLeft_Btn.setImage(O_img, for: .normal)

            }
            
        case "center":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                center_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                center_Btn.setImage(O_img, for: .normal)
            }
            
        case "middle_right":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                middleRight_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                middleRight_Btn.setImage(O_img, for: .normal)

            }
            
        case "bottom_left":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                bottomLeft_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                bottomLeft_Btn.setImage(O_img, for: .normal)

            }
            
        case "bottom_middle":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                bottomMiddle_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                bottomMiddle_Btn.setImage(O_img, for: .normal)

            }
            
        case "bottom_right":
            
            if (playerSymbol == "X"){
                //place the x image on that button
                bottomRight_Btn.setImage(X_img, for: .normal)
            }
            else{
                //place an O image
                bottomRight_Btn.setImage(O_img, for: .normal)
            }
            
        default:
            
            print("Weird...")
            
        }
   
    }
    
    //This will remove everything after the @ symbol in an email
    func formatEmail(email:String) -> String{
        
        let emailParts = email.split(separator: "@")
        return String(emailParts[0])
        
    }
    
}
