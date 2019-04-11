//
//  PlayBtLaunchScreenViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/29/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class PlayBtOpeningScreenViewController: UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueExistingGameButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RandomOpponentSegue", sender: self)
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "NewGameSegue", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "RandomOpponentSegue", sender: self)
    }
    
}
