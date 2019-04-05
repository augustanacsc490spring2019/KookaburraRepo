//
//  LaunchScreen.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/19/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit
import Foundation

class OpeningScreen: UIViewController {
    
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var labelMinus10: UILabel!
    @IBOutlet weak var label15: UILabel!
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var demotionImage: UIImageView!
    @IBOutlet weak var promotionImage: UIImageView!
    @IBOutlet weak var levelUpBar: UIProgressView!
    @IBOutlet weak var levelDownBar: UIProgressView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        UserDefaults.standard.set(0, forKey: "playerGold")
        UserDefaults.standard.set(0, forKey: "playerRank")
        UserDefaults.standard.set(0, forKey: "rankingPoints")
        UserDefaults.standard.synchronize()
        labelMinus10.text = "-10"
        label15.text = "15"
        demotionImage.image = UIImage(named: "demotionSymbol.png")
        let points = UserDefaults.standard.integer(forKey: "rankingPoints")
        let rank = UserDefaults.standard.integer(forKey: "playerRank")
        //levels the player up if they get enough points
        if points > 15{
            if rank == 3{
                //gold + 1000
            } else {
                var rank = UserDefaults.standard.integer(forKey: "playerRank")
                rank = rank + 1
                UserDefaults.standard.set(rank, forKey: "playerRank")
            }
            UserDefaults.standard.set(0, forKey: "rankingPoints")
        } else if points < -10{//level player down if they don't have enough points
            if rank > 0{
                var rank = UserDefaults.standard.integer(forKey: "playerRank")
                rank = rank - 1
                UserDefaults.standard.set(rank, forKey: "playerRank")
            }
        } else if rank == 1{
            if points < 0 {//bronze players can't have negaative points
                UserDefaults.standard.set(0, forKey: "rankingPoints")
            }
        }
        if rank == 3{//diamond
            promotionImage.image = UIImage(named: "championTrophy.png")
            rankImage.image = UIImage(named: "rankDiamond.png")
        } else { //bronze, silver, or gold
            promotionImage.image = UIImage(named: "promotionSymbol.png")
            if rank == 0{
                 rankImage.image = UIImage(named: "rankBronze.png")
            } else if rank == 1{
                 rankImage.image = UIImage(named: "rankSilver.png")
            } else {
                rankImage.image = UIImage(named: "rankGold.png")
            }
        }
        rankPointsLabel.text = ("Ranking points: \(points)")
        let transform = CGAffineTransform(rotationAngle: 3.14159); // Flip view horizontally?
        levelDownBar.transform = transform;
        //levelDownBar.progress = 0.75 //for test
        if points < 0 {
            levelDownBar.progress = Float(points)/(-10.0)
            levelUpBar.progress = 0.01
        } else if points > 0 {
            levelUpBar.progress = Float(points)/15.0
            levelDownBar.progress = 0.01
        } else {
            levelDownBar.progress = 0.01
            levelUpBar.progress = 0.01
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet weak var rankPointsLabel: UILabel!
    
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
        //self.performSegue(withIdentifier: "QuickTestSegue", sender: self)
        performSegue(withIdentifier: "PlacePiecesSegue", sender: nil)
    }
    
    @IBAction func rankPointsTest(_ sender: Any) {
        NSLog("Points please")
         var points = UserDefaults.standard.integer(forKey: "rankingPoints")
        points = points + 2
        UserDefaults.standard.set(points, forKey: "rankingPoints")
        UserDefaults.standard.synchronize()
    }
    
}
