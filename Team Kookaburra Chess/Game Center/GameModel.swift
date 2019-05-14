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

//struct GameModel {
struct GameModel: Codable{
    //NOTE: We need to make this class Codable for serialization in order to send it's data to Game Center.
    //currently BoardCell isn't Codable which causes problems. 
    
    //var lastMove: Move?
    //var boardCells: [BoardCell]
    var pieceNamesArray = [[String]]()
    //var pieceNamesArray = [[String]](repeating: [String](repeating: 0, count: 8), count: 8) //8 by 8 array of Strings
    
    var winner: Player?
    
    var currentPlayer: Player {
        return isWhiteTurn ? .white : .black
    }
    
    var currentOpponent: Player {
        return isWhiteTurn ? .black : .white
    }
    
    var messageToDisplay: String {
        return "generic message for now, possibly about who's turn it is"
    }
    
//    var isCapturingPiece: Bool {
//        return currentMill != nil
//    }
    
    //ignore all of this for now. I thought about going down a rabbit hole where placing pieces didn't get
    //determined based off a blank chessboard but were saved here instead.
    var whiteHasSetPieces: Bool = false
    var blackHasSetPieces: Bool = false
    var piecesAreSet: Bool = false
    //var neitherHasSetPieces = Bool() / not sure if need this. See initializer and update turn
    
    var isWhiteTurn = Bool() //pay attention to how this is used in Nine Knights
    
    init() {
        //self.currentPlayer = randomPlayer()
        //neitherHasSetPieces = true
        self.isWhiteTurn = randomPlayer() //this pattern of having this set from the parameter was in Nine Knights. Not sure why or if I should use it for other fields.
        //print("GameModel init called. isWhiteTurn = \(self.isWhiteTurn). currentPlayer = \(self.currentPlayer)")
        
        //boardCells = [BoardCell]()
        
    }
    
    mutating func checkPiecesAreSet(){
        piecesAreSet = whiteHasSetPieces && blackHasSetPieces
        if (piecesAreSet){
            isWhiteTurn = true
        }
    }
    
    func randomPlayer() -> Bool {
        //print("randomPlayer called")
        let number = Int.random(in: 0...1)
        if number == 0 {
            return isWhiteTurn
        } else {
            return !isWhiteTurn
        }
    }
    
    mutating func updateTurn() {
        print("mode.updateTurn called. whiteHasSetPieces = \(self.whiteHasSetPieces). blackHasSetPieces = \(self.blackHasSetPieces)")
        //neitherHasSetPieces = true
        if(!piecesAreSet){
            if(whiteHasSetPieces){
                isWhiteTurn = false
            } else {
                isWhiteTurn = true
            }
        }
        checkPiecesAreSet()
        //probably need something to check if first move and make white's turn
        if (piecesAreSet){
            self.isWhiteTurn = !isWhiteTurn
        }
        print("end of gameModel.updateturn. isWhiteTurn = \(self.isWhiteTurn)")
    }
    
    func updatePieceNamesArray(chessPieceArray: [[ChessPiece]]) -> [[String]]{
        print("updatePieceNamesArray called")
        var pieceNamesArray = [[String]]()
        for row in 0...7{
            for col in 0...7{
                //print("row: \(row), col: \(col)")
                let currentPiece = chessPieceArray[row][col]
                //print("read currentPiece")
                currentPiece.setupSymbol()
                let pieceName = currentPiece.symbol
                pieceNamesArray.append([pieceName])
            }
        }
        return pieceNamesArray
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


