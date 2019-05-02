//
//  LevelUpProgress.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 4/1/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

//PSEUDOCODE

//if player ranking pounts are >= 0{
//  make the bar blue
//  make progress out of 15
//  change icon to promotion icon
//  change label to points/15
//} else if 
// } else { // < 0
//  make the bar red
// make progress out of 10 (use absolute value)
//  change icon to demotion icon
//  change label to points/-10
//}
//if player.rank == diamond{
//make the promotion icon into the trophy icon
//}
//if player ranking points >= 15{
//      switch player rank{
//          case bronze:
//              player rank = silver
//              display silver banner
//          case silver:
//              player rank = gold
//              display gold banner
//          case gold:
//                player rank = diamond
//                display diamond banner
//          case diamond:
//              player.gold = player.gold + 1000
//              display champion banner
//          }
//  }
//      reset player points to 0
//  } else if player rank == bronze {
//      if player ranking points < 0{
//          player ranking points = 0
//  }
//} else if player ranking points <= -10{
//      switch player rank{
//          case silver:
//              player rank = bronze
//              display silver banner
//          case gold:
//              player rank = silver
//              display gold banner
//          case diamond:
//                player rank = gold
//                display diamond banner
//          }
//}

