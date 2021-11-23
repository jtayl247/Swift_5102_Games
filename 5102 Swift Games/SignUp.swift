//
//  SignUp.swift
//  5102 Swift Games
//
//  Created by Erik Taylor on 10/19/21.
//
//  This will be where we let user log in / sign up for Tic-tac-toe game

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUp: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    //Used to connect to Firebase
    let database = Database.database().reference()
    
    var UserID : String!
    
    
    //When the sign up screen first appears
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Delegates for text fields
        self.email.delegate = self
        self.password.delegate = self
        
        //Checks if user already exists in Firebase
        if let user = Auth.auth().currentUser{
            
            self.UserID = user.uid
            print("User already signed up...User is: \(String(describing: UserID))")
            goToMainScreen()
            
        }
        
    }
    
    
    //Firebase create user after button is pressed -- with error checking
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
    
    
    
    //Format email --> remove @gmail.com or other domain from email
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
    
    //Hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    //This is where you update values/params before transitioning to main game screen
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


