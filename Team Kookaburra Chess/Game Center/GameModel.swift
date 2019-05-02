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

struct GameModel: Codable {
    var turn: Int
    //probably don't want a turn counter but mayve a boolean to see if it's the first turn
    //use the boolean to determine if placing pieces or loading board
    var state: State
    var lastMove: Move?
    var winner: Player?
    
    var currentPlayer: Player {
        return isKnightTurn ? .knight : .troll
    }
    
    var currentOpponent: Player {
        return isKnightTurn ? .troll : .knight
    }
    
    //I don't think we'll need this
    var messageToDisplay: String {
        let playerName = isKnightTurn ? "Knight" : "Troll"
        
//        if isCapturingPiece {
//            return "Take an opponent's piece!"
//        }
        
        let stateAction: String
        switch state {
        case .placement:
            stateAction = "place"
            
        case .movement:
            if let winner = winner {
                return "\(winner == .knight ? "Knight" : "Troll")'s win!"
            } else {
                stateAction = "move"
            }
        }
        
        return "\(playerName)'s turn to \(stateAction)"
    }
    
    
    private(set) var isKnightTurn: Bool
    private let positions: [GridCoordinate]
    
    private let maxTokenCount = 18
    private let minPlayerTokenCount = 3
    
    init(isKnightTurn: Bool = true) {
        self.isKnightTurn = isKnightTurn
        
        turn = 0
        state = .placement
        
        positions = [
            GridCoordinate(x: .min, y: .max, layer: .outer),
            GridCoordinate(x: .mid, y: .max, layer: .outer),
            GridCoordinate(x: .max, y: .max, layer: .outer),
            GridCoordinate(x: .max, y: .mid, layer: .outer),
            GridCoordinate(x: .max, y: .min, layer: .outer),
            GridCoordinate(x: .mid, y: .min, layer: .outer),
            GridCoordinate(x: .min, y: .min, layer: .outer),
            GridCoordinate(x: .min, y: .mid, layer: .outer),
            GridCoordinate(x: .min, y: .max, layer: .middle),
            GridCoordinate(x: .mid, y: .max, layer: .middle),
            GridCoordinate(x: .max, y: .max, layer: .middle),
            GridCoordinate(x: .max, y: .mid, layer: .middle),
            GridCoordinate(x: .max, y: .min, layer: .middle),
            GridCoordinate(x: .mid, y: .min, layer: .middle),
            GridCoordinate(x: .min, y: .min, layer: .middle),
            GridCoordinate(x: .min, y: .mid, layer: .middle),
            GridCoordinate(x: .min, y: .max, layer: .center),
            GridCoordinate(x: .mid, y: .max, layer: .center),
            GridCoordinate(x: .max, y: .max, layer: .center),
            GridCoordinate(x: .max, y: .mid, layer: .center),
            GridCoordinate(x: .max, y: .min, layer: .center),
            GridCoordinate(x: .mid, y: .min, layer: .center),
            GridCoordinate(x: .min, y: .min, layer: .center),
            GridCoordinate(x: .min, y: .mid, layer: .center),
        ]
    }
    
    func neighbors(at coord: GridCoordinate) -> [GridCoordinate] {
        var neighbors = [GridCoordinate]()
        
        switch coord.x {
        case .mid:
            neighbors.append(GridCoordinate(x: .min, y: coord.y, layer: coord.layer))
            neighbors.append(GridCoordinate(x: .max, y: coord.y, layer: coord.layer))
            
        case .min, .max:
            if coord.y == .mid {
                switch coord.layer {
                case .middle:
                    neighbors.append(GridCoordinate(x: coord.x, y: coord.y, layer: .outer))
                    neighbors.append(GridCoordinate(x: coord.x, y: coord.y, layer: .center))
                case .center, .outer:
                    neighbors.append(GridCoordinate(x: coord.x, y: coord.y, layer: .middle))
                }
            } else {
                neighbors.append(GridCoordinate(x: .mid, y: coord.y, layer: coord.layer))
            }
        }
        
        switch coord.y {
        case .mid:
            neighbors.append(GridCoordinate(x: coord.x, y: .min, layer: coord.layer))
            neighbors.append(GridCoordinate(x: coord.x, y: .max, layer: coord.layer))
            
        case .min, .max:
            if coord.x == .mid {
                switch coord.layer {
                case .middle:
                    neighbors.append(GridCoordinate(x: coord.x, y: coord.y, layer: .outer))
                    neighbors.append(GridCoordinate(x: coord.x, y: coord.y, layer: .center))
                case .center, .outer:
                    neighbors.append(GridCoordinate(x: coord.x, y: coord.y, layer: .middle))
                }
            } else {
                neighbors.append(GridCoordinate(x: coord.x, y: .mid, layer: coord.layer))
            }
        }
        
        return neighbors
    }
    
    //This functionality is in the chessBoard class I think
//    func mill(containing token: Token) -> [Token]? {
//        var coordsToCheck = [token.coord]
//
//        var xPositionsToCheck: [GridPosition] = [.min, .mid, .max]
//        xPositionsToCheck.remove(at: token.coord.x.rawValue)
//
//        guard let firstXPosition = xPositionsToCheck.first, let lastXPosition = xPositionsToCheck.last else {
//            return nil
//        }
//
//        var yPositionsToCheck: [GridPosition] = [.min, .mid, .max]
//        yPositionsToCheck.remove(at: token.coord.y.rawValue)
//
//        guard let firstYPosition = yPositionsToCheck.first, let lastYPosition = yPositionsToCheck.last else {
//            return nil
//        }
//
//        var layersToCheck: [GridLayer] = [.outer, .middle, .center]
//        layersToCheck.remove(at: token.coord.layer.rawValue)
//
//        guard let firstLayer = layersToCheck.first, let lastLayer = layersToCheck.last else {
//            return nil
//        }
//
//        switch token.coord.x {
//        case .mid:
//            coordsToCheck.append(GridCoordinate(x: token.coord.x, y: token.coord.y, layer: firstLayer))
//            coordsToCheck.append(GridCoordinate(x: token.coord.x, y: token.coord.y, layer: lastLayer))
//
//        case .min, .max:
//            coordsToCheck.append(GridCoordinate(x: token.coord.x, y: firstYPosition, layer: token.coord.layer))
//            coordsToCheck.append(GridCoordinate(x: token.coord.x, y: lastYPosition, layer: token.coord.layer))
//        }
//
//        let validHorizontalMillTokens = tokens.filter {
//            return $0.player == token.player && coordsToCheck.contains($0.coord)
//        }
//
//        if validHorizontalMillTokens.count == 3 {
//            return validHorizontalMillTokens
//        }
//
//        coordsToCheck = [token.coord]
//
//        switch token.coord.y {
//        case .mid:
//            coordsToCheck.append(GridCoordinate(x: token.coord.x, y: token.coord.y, layer: firstLayer))
//            coordsToCheck.append(GridCoordinate(x: token.coord.x, y: token.coord.y, layer: lastLayer))
//
//        case .min, .max:
//            coordsToCheck.append(GridCoordinate(x: firstXPosition, y: token.coord.y, layer: token.coord.layer))
//            coordsToCheck.append(GridCoordinate(x: lastXPosition, y: token.coord.y, layer: token.coord.layer))
//        }
//
//        let validVerticalMillTokens = tokens.filter {
//            return $0.player == token.player && coordsToCheck.contains($0.coord)
//        }
//
//        if validVerticalMillTokens.count == 3 {
//            return validVerticalMillTokens
//        }
//
//        return nil
//    }
//
//
//
//    mutating func move(from: GridCoordinate, to: GridCoordinate) {
//        guard let index = tokens.firstIndex(where: { $0.coord == from }) else {
//            return
//        }
//
//        let previousToken = tokens[index]
//        let movedToken = Token(player: previousToken.player, coord: to)
//
//        let millToRemove = mill(containing: previousToken) ?? []
//
//        if !millToRemove.isEmpty {
//            millToRemove.forEach { tokenToRemove in
//                guard let index = millTokens.index(of: tokenToRemove) else {
//                    return
//                }
//
//                self.millTokens.remove(at: index)
//            }
//        }
//
//        tokens[index] = movedToken
//        lastMove = Move(start: from, end: to)
//
//        if !millToRemove.isEmpty {
//            for removedToken in millToRemove where removedToken != previousToken && mill(containing: removedToken) != nil {
//                millTokens.append(removedToken)
//            }
//        }
    
    
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
        case knight, troll
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

