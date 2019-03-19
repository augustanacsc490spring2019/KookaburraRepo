//
//  history.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 3/18/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//
//  Originally created by Mikael Mukhsikaroyan on 11/1/16.
//  Used and modified under MIT License

import Foundation

class History {
    
    // each dictionary will contain "start" and "end" move
    // Example: moves[0] = ["start": index1, "end": index2]
    var moves = [[String: BoardIndex]]()
    
    func showHistory() {
        for (i, m) in moves.enumerated() {
            let start = m["start"]
            let end = m["end"]
            print("Showing History======================")
            print("MOVE \(i+1)")
            print("Moved from: \(start?.valueCol.rawValue), \(start?.valueRow.rawValue)")
            print("To: \(end?.valueCol.rawValue), \(end?.valueRow.rawValue)")
        }
    }
    
    func movesAsIndices() -> [BoardIndex] {
        let indices = [BoardIndex]()
        
        return indices
    }
    
}
