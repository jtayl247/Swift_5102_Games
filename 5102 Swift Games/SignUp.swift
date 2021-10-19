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



class SignUp: UIViewController{
    //For now, just take user to main tic-tac-toe screen after button press

    @IBOutlet weak var btnSignUp: UIButton!
    
    
    @IBAction func SignUpPress(_ sender: Any) {
        //Present main tic-tac-toe view
        let story = UIStoryboard(name: "Main", bundle: nil)
        let ticTacToe = story.instantiateViewController(withIdentifier: "TicTacToeView")
        let navigation = UINavigationController(rootViewController: ticTacToe)
        self.view.addSubview(navigation.view)
        self.addChild(navigation)
        navigation.didMove(toParent: self)
    }
    
}
