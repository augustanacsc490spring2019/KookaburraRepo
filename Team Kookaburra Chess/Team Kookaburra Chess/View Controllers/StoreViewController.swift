//
//  StoreViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/29/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var piecePic: UIImageView!
    @IBOutlet weak var pieceInfo: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var buyOrSellButton: UIButton!
    @IBOutlet weak var getMoreGoldButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackFromSearchForFriendsSegue", sender: self)
    }
}
