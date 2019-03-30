//
//  LaunchScreen.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/19/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class OpeningScreen: UIViewController {
    
    @IBOutlet weak var gameTitle: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func myFriendButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "MyFriendsBtSegue", sender: self)
    }
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "StoreSegue", sender: self)
    }
    
    @IBAction func myStatsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "MyStatsSegue", sender: self)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "PlayBtOpeningScreenSegue", sender: self)
    }
    
    @IBAction func quickTestButtonPressed(_ sender: Any) {
    }
}
