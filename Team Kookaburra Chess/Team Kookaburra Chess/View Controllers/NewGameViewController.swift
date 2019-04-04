//
//  NewGameViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit

class NewGameViewController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func typeNewGameBackBtPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "TypeOfNewGameBackBtSegue", sender: self)
    }
    
    @IBAction func randomOpponentButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ChoseAFriendSegue", sender: self)
    }
    
    @IBAction func choseFriendButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ChoseAFriendSegue", sender: self)
        
    }
}
