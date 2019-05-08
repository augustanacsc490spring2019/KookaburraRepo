/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import GameKit

struct GameModel {
    //NOTE: this used to inherit the Codable protocol. It broke when I changed var tokens: [Token] to
    //var boardCells: [BoardCell]. It was fixed at least for compiling when I make a struct called BoardCell
    //in this class instead, which is commented out.
    
    //var lastMove: Move?
    var boardCells: [BoardCell]
    var winner: Player?
    
    var currentPlayer: Player {
        return isWhiteTurn ? .white : .black
    }
    
    var currentOpponent: Player {
        return isWhiteTurn ? .white : .black
    }
    
//    var messageToDisplay: String {
//
//    }
    
//    var isCapturingPiece: Bool {
//        return currentMill != nil
//    }
    
    
    private(set) var isWhiteTurn: Bool //pay attention to how this is used in Nine Knights
    
    init(isWhiteTurn: Bool = true) {
        self.isWhiteTurn = isWhiteTurn
        boardCells = [BoardCell]()
    }
    
    
   
//    mutating func advance() {
//        if tokensPlaced == maxTokenCount && state == .placement {
//            state = .movement
//        }
//
//        turn += 1
//        currentMill = nil
//
//        if state == .movement {
//            if tokenCount(for: currentOpponent) == 2 || !canMove(currentOpponent) {
//                winner = currentPlayer
//            } else {
//                isKnightTurn = !isKnightTurn
//            }
//        } else {
//            isKnightTurn = !isKnightTurn
//        }
//    }
    

    
//    func canMove(_ player: Player) -> Bool {
//        let playerTokens = tokens.filter { token in
//            return token.player == player
//        }
//
//        for token in playerTokens {
//            let emptyNeighbors = neighbors(at: token.coord).filter({ emptyCoordinates.contains($0) })
//            if !emptyNeighbors.isEmpty {
//                return true
//            }
//        }
//
//        return false
//    }
}

// MARK: - Types

extension GameModel {
    enum Player: String, Codable {
        case white, black
    }
    
    enum State: Int, Codable {
        case placement
        case movement
    }
    
    enum GridPosition: Int, Codable {
        case min, mid, max
    }
    
    enum GridLayer: Int, Codable {
        case outer, middle, center
    }
    
    struct GridCoordinate: Codable, Equatable {
        let x, y: GridPosition
        let layer: GridLayer
    }
    
    struct Token: Codable, Equatable {
        let player: Player
        let coord: GridCoordinate
    }
    
//    struct BoardCell: Codable, Equatable {
//
//    }
    
    struct Move: Codable, Equatable {
        var placed: GridCoordinate?
        var removed: GridCoordinate?
        var start: GridCoordinate?
        var end: GridCoordinate?
        
        init(placed: GridCoordinate?) {
            self.placed = placed
        }
        
        init(removed: GridCoordinate?) {
            self.removed = removed
        }
        
        init(start: GridCoordinate?, end: GridCoordinate?) {
            self.start = start
            self.end = end
        }
    }
}


