//
//  SaveLoadGameData.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 5/13/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//
// Tutorial used: https://www.raywenderlich.com/2463-how-to-save-your-game-s-data-part-1-2
//

import Foundation

class SaveLoadGameData: NSObject  {
    
    var SSGameDataTotalWinsKey: NSString = "total_wins"
    var SSGameDataWinStreakKey: NSString = "win_streak"
    var SSGameDataTotalGamesPlayedKey: NSString = "total_games_played"
    var SSGameDataLoseStreakKey: NSString = "lose_streak"
    
    
    func encodeWithCoder(encoder: NSCoder){
        encoder.encode(SSGameDataTotalWinsKey, forKey: SSGameDataTotalWinsKey as String)
        encoder.encode(SSGameDataWinStreakKey, forKey: SSGameDataWinStreakKey as String)
        encoder.encode(SSGameDataTotalGamesPlayedKey, forKey: SSGameDataTotalGamesPlayedKey as String)
        encoder.encode(SSGameDataLoseStreakKey, forKey: SSGameDataLoseStreakKey as String)
    }
    
    func initWithCoder(decoder: NSCoder){
        SSGameDataTotalWinsKey = decoder.decodeObject(forKey: SSGameDataTotalWinsKey as String) as! NSString
        SSGameDataWinStreakKey = decoder.decodeObject(forKey: SSGameDataWinStreakKey as String) as! NSString
        SSGameDataTotalGamesPlayedKey = decoder.decodeObject(forKey: SSGameDataTotalGamesPlayedKey as String) as! NSString
        SSGameDataLoseStreakKey = decoder.decodeObject(forKey: SSGameDataLoseStreakKey as String) as! NSString
    }
    
//    func filePath(file:  NSString) -> NSString {
//        var file = nil
//        if !file {
//            file = NSSearchPathForDirectoriesInDomains(NSHomeDirectory, 1, YES)
//            stringByAppendingPathComponent: "gameData"
//        }
//        return file
//    }
    
}

