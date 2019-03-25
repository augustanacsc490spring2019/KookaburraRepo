//
//  chessPiece.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 3/18/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
// Originally created by Mikael Mukhsikaroyan on 11/1/16.
//  Used and modified under MIT License

import UIKit

enum PieceType {
    case king
    case dummy
    //tier 5
    
    //tier 4
    case queen
    //tier 3
    case ghostQueen
    case rook
    case knight
    case bishop
    //tier 2
    case scout
    case ogre
    case orcWarrior
    case elephant
    case manAtArms
    case swordsman
    case pikeman
    case archer
    case royalGuard
    case demon
    //tier 1
    case pawn
    case monk
    case dwarf
    case gargoyle
    case goblin
    case footSoldier
}

class ChessPiece {
    
    var row: Int = 0 {
        didSet {
            updateIndex()
        }
    }
    var col: Int = 0 {
        didSet {
            updateIndex()
        }
    }
    
    var bIndex: BoardIndex
    var symbol: String
    var symbolImage: UIImage
    var color: UIColor
    var type: PieceType
    var advancingByTwo = false // Only for pawn type
    var firstMove = true // Only for king type
    //var pawnFirstMove = true // only for pawn type
    var playerColor: UIColor
    
    init(row: Int, column: Int, color: UIColor, type: PieceType, player: UIColor) {
        self.row = row
        self.col = column
        self.bIndex = BoardIndex(row: row, column: col)
        self.color = color
        self.type = type
        self.symbol = ""
        self.symbolImage = UIImage(named:"blackPawn.png")!
        self.playerColor = player
        setupSymbol()
    }
    
    func updateIndex() {
        let dir: BDirection = playerColor == .white ? .bottom : .top
        bIndex.updateValue(fromDirection: dir)
        //showPieceInfo()
    }
    
    func showPieceInfo() {
        print("PIECE============")
        print("Value Row: \(bIndex.valueRow.rawValue)")
        print("Value Col: \(bIndex.valueCol.rawValue)")
    }
    
    private func setupSymbol() {
        switch type {
        case .pawn:
            symbol = "blackPawn.png"
        case .rook:
            symbol = "testRook.png"
        case .knight:
            symbol = "blackKnight.png"
        case .bishop:
            symbol = "blackBishop.png"
        case .king:
            symbol = "blackKing.png"
        case .queen:
            symbol = "blackQueen.png"
        case .dummy:
            symbol = "blankPiece.png"
        case .ghostQueen:
            symbol = "blackGhostQueen.png"
        case .dwarf:
            symbol = "blackDwarf.png"
        case .footSoldier:
            symbol = "blackFootSoldier.png"
        case .monk:
            symbol = "blackMonk.png"
        case .gargoyle:
            symbol = "blackGargoyle.png"
        case .goblin:
            symbol = "blackGoblin.png"
        case .scout:
            symbol = "blackScout.png"
        case .ogre:
            symbol = "blackOgre.png"
        case .orcWarrior:
            symbol = "blackOrcWarrior.png"
        case .elephant:
            symbol = "blackElephant.png"
        case .manAtArms:
            symbol = "blackManAtArms.png"
        case .swordsman:
            symbol = "blackSwordsman.png"
        case .archer:
            symbol = "blackArcher.png"
        case .swordsman:
            symbol = "blackSwordsman.png"
        case .pikeman:
            symbol = "blackPikeman.png"
        case .royalGuard:
            symbol = "blackGuard.png"
        case .demon:
            symbol = "blackDemon.png"
        }
        // NSLog(symbol)
        self.symbolImage = UIImage(named:symbol)!
    }
    
    /** Checks to see if the direction the piece is moving is the way this piece type is allowed to move. Doesn't take into account the state of the board */
    func isMovementAppropriate(toIndex dest: BoardIndex) -> Bool {
        switch type {
        case .pawn:
            return checkPawn(dest: dest)
        case .rook:
            return checkRook(dest: dest)
        case .knight:
            return checkKnight(dest: dest)
        case .bishop:
            return checkBishop(dest: dest)
        case .queen:
            return checkQueen(dest: dest)
        case .king:
            return checkKing(dest: dest)
        case .dummy:
            return false
        case .ghostQueen:
            //TODO
            return false
        case .monk:
            //TODO
            return false
        case .dwarf:
            //TODO
            return false
        case .gargoyle:
            //TODO
            return false
        case .goblin:
            return false
        case .footSoldier:
            //TODO
            return false
        case .scout:
            //TODO
            return false
        case .ogre:
            //TODO
            return false
        case .orcWarrior:
            //TODO
            return false
        case .elephant:
            //TODO
            return false
        case .manAtArms:
            //TODO
            return false
        case .swordsman:
            //TODO
            return false
        case .pikeman:
            //TODO
            return false
        case .archer:
            //TODO
            return false
        case .royalGuard:
            //TODO
            return false
        case .demon:
            //TODO
            return false
        }
    }
    
    private func checkPawn(dest: BoardIndex) -> Bool {
        // is it advancing by 2
        // check if the move is in the same column
        if self.col == dest.column {
            // can only move 2 forward if first time moving pawn
            if color != playerColor {
                if row == 1 && dest.row == 3 {
                    advancingByTwo = true
                    return true
                }
            } else {
                if row == 6 && dest.row == 4 {
                    advancingByTwo = true
                    return true
                }
            }
        }
        advancingByTwo = false
        // the move direction depends on the color of the piece
        var moveDirection: Int
        if color == playerColor {
            moveDirection = -1
        } else {
            moveDirection = 1
        }
        //let moveDirection = color == .black ? -1 : 1
        // if the movement is only 1 row up/down
        if dest.row == self.row + moveDirection {
            // check for diagonal movement and forward movement
            if (dest.column == self.col - 1) || (dest.column == self.col) || (dest.column == self.col + 1) {
                return true
            }
        }
        return false
    }
    
    private func checkRook(dest: BoardIndex) -> Bool {
        if self.row == dest.row || self.col == dest.column {
            return true
        }
        return false
    }
    
    private func checkKnight(dest: BoardIndex) -> Bool {
        let validMoves =  [(self.row - 1, self.col + 2), (self.row - 2, self.col + 1), (self.row - 2, self.col - 1), (self.row - 1, self.col - 2), (self.row + 1, self.col - 2), (self.row + 2, self.col - 1), (self.row + 2, self.col + 1), (self.row + 1, self.col + 2)]
        
        for (validRow, validCol) in validMoves {
            if dest.row == validRow && dest.column == validCol {
                return true
            }
        }
        return false
    }
    
    private func checkBishop(dest: BoardIndex) -> Bool {
        if abs(dest.row - self.row) == abs(dest.column - self.col) {
            return true
        }
        return false
    }
    
    private func checkQueen(dest: BoardIndex) -> Bool {
        // check diagonal move
        if abs(dest.row - self.row) == abs(dest.column - self.col) {
            return true
        }
        // check rook-like move
        if self.row == dest.row || self.col == dest.column {
            return true
        }
        return false
    }
    
    private func checkKing(dest: BoardIndex) -> Bool {
        // king only moves one space at a time
        let rowDelta = abs(self.row - dest.row)
        let colDelta = abs(self.col - dest.column)
        if (rowDelta == 0 || rowDelta == 1) && (colDelta == 0 || colDelta == 1) {
            return true
        }
        if firstMove {
            if rowDelta == 0 && colDelta == 2 {
                return true
            }
        }
        return false
    }
    
    func printInfo() -> String {
        var pColor = "Clear"
        if color == .white {
            pColor = "White"
        } else if color == .black {
            pColor = "Black"
        }
        return "\(pColor) \(symbol)"
    }
    
}
