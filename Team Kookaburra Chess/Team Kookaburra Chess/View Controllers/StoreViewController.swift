//
//  StoreViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/29/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var piecePic: UIImageView!
    @IBOutlet weak var pieceInfo: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var buyOrSellButton: UIButton!
    @IBOutlet weak var getMoreGoldButton: UIButton!
    var gold: Int = 0
    var pickerData: [String] = [String]()
    
    override func viewDidLoad(){
        gold = UserDefaults.standard.integer(forKey: "playerGold")
        goldLabel.text = "\(gold)"
        picker.delegate = self
        picker.dataSource = self
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackFromStoreSegue", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func sellPiece(){
        
    }
    
    func buyPiece(){
        
    }
}
