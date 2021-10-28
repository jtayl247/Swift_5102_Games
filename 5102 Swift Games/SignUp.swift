//
//  SignUp.swift
//  5102 Swift Games
//
//  Created by Erik Taylor on 10/19/21.
//
//  This will be where we let user log in / sign up for Tic-tac-toe game
//  Until we get FireBase Auth set up, this view will only serve to segue into main tic-tac-toe view
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignUp: UIViewController{
    //For now, just take user to main tic-tac-toe screen after button press

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let database = Database.database().reference()
    
    var UserID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = Auth.auth().currentUser{
            self.UserID = user.uid
            print("User already signed up...User is: \(String(describing: UserID))")
            goToMainScreen()
        }
    }
    
    
    @IBAction func SignUpPress(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) {
            (user, error) in
            
            if let error = error{
                print("Cannot login: \(error)")
            }
            else{
                print("UserID: \(String(describing: user?.user.uid))")
                self.database.child("TicTacToe").child("Users").child(self.formatEmail(email:(user?.user.email)!)).child("Request").setValue((user?.user.uid)!)
                self.goToMainScreen()
            }
        }
    }
    
    func formatEmail(email:String) -> String{
        let EmailArr = email.split(separator: "@")
        return String(EmailArr[0])
    }
    
    func goToMainScreen(){
        DispatchQueue.main.async {
            //Present main tic-tac-toe view
            self.performSegue(withIdentifier: "showGame", sender: nil)
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showGame") {
            if let TTTGame = segue.destination as? GameBoard{
                if let user = Auth.auth().currentUser {
                TTTGame.UserID = user.uid
                TTTGame.UserEmail = user.email
            }
        }
    }
    }
}


