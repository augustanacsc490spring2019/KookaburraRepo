//
//  LaunchScreen.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/19/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBAction func myFriendsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "myFriendsButtonSegue", sender: self)
    }
    
    @IBAction func storeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "storeButtonSegue", sender: self)
    }
    
    @IBAction func myStatsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "myStatsButtonSegue", sender: self)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "playBtLaunchScreenSegue", sender: self)
    }
}
