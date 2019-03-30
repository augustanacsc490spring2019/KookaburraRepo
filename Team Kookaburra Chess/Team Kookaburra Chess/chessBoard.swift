//
//  chessBoard.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 3/18/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//  Originally created by Mikael Mukhsikaroyan on 11/1/16.
//  Used and modified under MIT License


import UIKit

protocol ChessBoardDelegate {
    func boardUpdated()
    func gameOver(withWinner winner: UIColor)
    func gameTied()
    func promote(pawn: ChessPiece)
}

class ChessBoard {
    
    var board = [[ChessPiece]]()
    var delegate: ChessBoardDelegate?
    var playerColor: UIColor!
    var history = History()
    
    init(playerColor color: UIColor) {
        self.playerColor = color
        let oneRow = Array(repeating: ChessPiece(row: 0, column: 0, color: .clear, type: .dummy, player: color), count: 8)
        board = Array(repeating: oneRow, count: 8)
        startNewGame()
    }
    
    func startNewGame() {
        let opponent: UIColor = playerColor == UIColor.white ? .black : .white
        for row in 0...7 {
            for col in 0...7 {
                switch row {
                case 0: // First row of chess board
                    switch col { // determine what piece to put in each column of first row
                    case 0:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .mage, player: playerColor)
                    case 1:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .camel, player: playerColor)
                    case 2:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .dragonRider, player: playerColor)
                    case 3:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .king, player: playerColor)
                    case 4:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .superKing, player: playerColor)
                    case 5:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .scout, player: playerColor)
                    case 6:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .archer, player: playerColor)
                    default:
                        board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .minotaur, player: playerColor)
                    }
                case 1:
                    board[row][col] = ChessPiece(row: row, column: col, color: opponent, type: .footSoldier, player: playerColor)
                case 6:
                    board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .dwarf, player: playerColor)
                case 7:
                    switch col { // determine what piece to put in each column of first row
                    case 0:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .centaur, player: playerColor)
                    case 1:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .unicorn, player: playerColor)
                    case 2:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .monopod, player: playerColor)
                    case 3:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .ogre, player: playerColor)
                    case 4:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .king, player: playerColor)
                    case 5:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .orcWarrior, player: playerColor)
                    case 6:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .pikeman, player: playerColor)
                    default:
                        board[row][col] = ChessPiece(row: row, column: col, color: playerColor, type: .gargoyle, player: playerColor)
                    }
                default:
                    board[row][col] = ChessPiece(row: row, column: col, color: .clear, type: .dummy, player: playerColor)
                }
            }
        }
        delegate?.boardUpdated()
    }
    
    func isAttackingOwnPiece(attackingPiece: ChessPiece, atIndex dest: BoardIndex) -> Bool {
        
        let destPiece = board[dest.row][dest.column]
        guard  !(destPiece.type == .dummy) else {
            // attacking an empty cell
            return false
        }
        
        return destPiece.color == attackingPiece.color
    }
    
    func getPossibleMoves(forPiece piece: ChessPiece) -> [BoardIndex] {
        
        var possibleMoves = [BoardIndex]()
        for row in 0...7 {
            for col in 0...7 {
                let dest = BoardIndex(row: row, column: col)
                if isMoveLegal(forPiece: piece, toIndex: dest, considerOwnPiece: true) {
                    possibleMoves.append(dest)
                }
            }
        }
        // make sure that by making this move, the player is not exposing his king
        var realPossibleMoves = [BoardIndex]()
        if piece.type == .king {
            //print("Checking \(possibleMoves.count) moves for king")
            for move in possibleMoves {
                if !canOpponentAttack(playerKing: piece, ifMovedTo: move) {
                    //print("Appending move for king")
                    if piece.firstMove && isMoveTwoCellsOver(forKing: piece, move: move) {
                        if isRookNext(toKing: piece, forMove: move) {
                            realPossibleMoves.append(move)
                        }
                    } else {
                        realPossibleMoves.append(move)
                    }
                }
            }
        } else {
            for move in possibleMoves {
                //print("BEFORE")
                //printBoard()
                if !doesMoveExposeKingToCheck(playerPiece: piece, toIndex: move) {
                    realPossibleMoves.append(move)
                }
                //print("AFTER")
                //printBoard()
            }
        }
        //print("\(realPossibleMoves.count) real moves")
        return possibleMoves
    }
    
    /// Makes the given move and checks for gameOver/tie and reports back through delegates
    func move(chessPiece: ChessPiece, fromIndex source: BoardIndex, toIndex dest: BoardIndex) {
        let dict = ["start": source, "end": dest]
        history.moves.append(dict)
        history.showHistory()
        if chessPiece.type == .king {
            chessPiece.firstMove = false
            if isMoveTwoCellsOver(forKing: chessPiece, move: dest) {
                //print("KING MOVED 2 Pieces OVER")
                board[dest.row][dest.column] = chessPiece
                chessPiece.row = dest.row
                chessPiece.col = dest.column
                board[source.row][source.column] = ChessPiece(row: source.row, column: source.column, color: .clear, type: .dummy, player: playerColor)
                let rook = board[dest.row][dest.column+1]
                board[dest.row][dest.column+1] = ChessPiece(row: dest.row, column: dest.column+1, color: .clear, type: .dummy, player: playerColor)
                rook.row = dest.row
                rook.col = dest.column - 1
                board[dest.row][dest.column-1] = rook
                
            } else {
                board[dest.row][dest.column] = chessPiece
                board[source.row][source.column] = ChessPiece(row: source.row, column: source.column, color: .clear, type: .dummy, player: playerColor)
                chessPiece.row = dest.row
                chessPiece.col = dest.column
            }
        } else {
            // add piece to new location
            board[dest.row][dest.column] = chessPiece
            // add a dummy piece at old location
            board[source.row][source.column] = ChessPiece(row: source.row, column: source.column, color: .clear, type: .dummy, player: playerColor)
            // update piece's location variables
            chessPiece.row = dest.row
            chessPiece.col = dest.column
        }
        
        if chessPiece.type == .pawn {
            if doesPawnNeedPromotion(pawn: (chessPiece)) {
                delegate?.promote(pawn: (chessPiece))
            }
        }
        
        // check if by making this move, the player has won the game
        if isWinner(player: chessPiece.color, byMove: dest) {
            delegate?.gameOver(withWinner: chessPiece.color)
        } else if isGameTie(withCurrentPlayer: chessPiece.color) {
            delegate?.gameTied()
        }
        
        delegate?.boardUpdated()
    }
    
    // MARK: - Move validations per piece type
    
    /// All move validations start here
    func isMoveLegal(forPiece piece: ChessPiece, toIndex dest: BoardIndex, considerOwnPiece consider: Bool) -> Bool {
        
        // Fix a bug. When checking if king can take opponent piece while under check by that piece
        if consider {
            if isAttackingOwnPiece(attackingPiece: piece, atIndex: dest) {
                return false
            }
        }
        // Moving on itself
        if piece.col == dest.column && piece.row == dest.row {
            //print("Moving on itself")
            return false
        }
        
        //        if !(piece is King) && doesMoveExposeKingToCheck(playerPiece: piece, toIndex: dest) {
        //            return false
        //        }
        
        switch piece.type {
        case .pawn:
            return isMoveValid(forPawn: piece, toIndex: dest)
        case .rook, .bishop, .queen:
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        case .knight:
            // The knight doesn't care about the state of the board because
            // it jumps over pieces. So there is no piece in the way for example
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .king :
            return isMoveValid(forKing: piece, toIndex: dest)
        case .dummy:
            return false
        case .unicorn:
            if piece.isMovementAppropriate(toIndex: dest) {
                if isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest){//queen move
                    return true
                } else if piece.checkKnight(dest: dest){//knight move
                    return true
                }
            }
            return false
        case .superKing:
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        case .griffin:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .mage:
            if piece.isMovementAppropriate(toIndex: dest) {
                if isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest){//queen move
                    return true
                } else if piece.checkKnight(dest: dest){//knight move
                    return true
                }
            }
            return false
        case .centaur:
            if piece.isMovementAppropriate(toIndex: dest) {
                if isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest){//queen move
                    return true
                } else if piece.checkKnight(dest: dest){//knight move
                    return true
                }
            }
            return false
        case .dragonRider:
            if piece.isMovementAppropriate(toIndex: dest){
                return  isMoveValid(forDragonRider: piece, toIndex: dest)
            }
            return  false
        case .bombard:
            return isMoveValid(forBombard: piece, toIndex: dest)
        case .manticore:
            return isMoveValid(forManticore: piece, toIndex: dest)
        case .ghostQueen:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .basilisk:
            return isMoveValid(forBasilisk: piece, toIndex: dest)
        case .fireDragon:
            return isMoveValid(forFireDragon: piece, toIndex: dest)
        case .iceDragon:
            return isMoveValid(forIceDragon: piece, toIndex: dest)
        case .minotaur:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .monopod:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .ship:
            return isMoveValid(forShip: piece, toIndex: dest)
        case .ballista:
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        case .batteringRam:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .trebuchet:
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        case .leftElf:
            return isMoveValid(forLeftElf: piece, toIndex: dest)
        case .rightElf:
            return isMoveValid(forRightElf: piece, toIndex: dest)
        case .camel:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .scout:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .ogre:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .orcWarrior:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .elephant:
            return isMoveValid(forElephant: piece, toIndex: dest)
        case .manAtArms:
            return isMoveValid(forManAtArms: piece, toIndex: dest)
        case .swordsman:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .pikeman:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .archer:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .royalGuard:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .demon:
            return isMoveValid(forDemon: piece, toIndex: dest)
        case .monk:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .dwarf:
            return isMoveValid(forDwarf: piece, toIndex: dest)
        case .gargoyle:
           return isMoveValid(forGargoyle: piece, toIndex: dest)
        case .goblin:
            if piece.isMovementAppropriate(toIndex: dest) == false {
                return false
            }
        case .footSoldier:
            return isMoveValid(forFootSoldier: piece, toIndex: dest)
        }
        
        return true
    }
    
    func isMoveValid(forPawn pawn: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        if pawn.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        
        // if it's same column
        if pawn.col == dest.column {
            if pawn.advancingByTwo {
                var moveDirection: Int
                if pawn.color == playerColor {
                    moveDirection = -1
                } else {
                    moveDirection = 1
                }
                // make sure there are no pieces in the way or at destination
                if board[dest.row][dest.column].type == .dummy && board[dest.row - moveDirection][dest.column].type == .dummy {
                    return true
                }
            } else {
                if board[dest.row][dest.column].type == .dummy {
                    return true
                }
            }
        } else { // attempting to attack diagonally
            // We will check that the destination cell does not contain a friend piece before getting to this cell
            // So just make sure the cell is not empty
            if !(board[dest.row][dest.column].type == .dummy) {
                return true
            }
        }
        
        return false
    }
    
    
    //because the dwarf's movement and attack patterns are not the same, it needs its own function
    func isMoveValid(forDwarf dwarf: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if dwarf.isMovementAppropriate(toIndex: dest) == false{
            return false
        }
        //if the move is to a different column (diagonal)
        //the dwarf can move here but not attack
        if dwarf.col != dest.column{
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        } else { //vertical move, can only be an attack
            //since we check elsewhere to avoid attacking friendly pieces, we only need to check if the space is empty
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forElephant piece: ChessPiece, toIndex dest: BoardIndex)-> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        //diagonal movement, must be an attack
        if dest.row != piece.row && dest.column != piece.col{
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
        } else { //orthagonal movement, can't be an attack
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forManAtArms piece: ChessPiece, toIndex dest: BoardIndex)-> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        //diagonal movement, can't be an attack
        if dest.row != piece.row && dest.column != piece.col{
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        } else { //orthagonal movement, must be an attack
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forDemon piece: ChessPiece, toIndex dest: BoardIndex)-> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        //same row, can't be an attack
        if dest.row == piece.row {
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        } else { //all other moves, must be an attack
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forLeftElf piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        if piece.color == .black{
            if dest.column > piece.col{
                return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
            }
        } else { //if piece.color == .white{
            if dest.column < piece.col{
                return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
            }
        }
        return false
    }
    
    func isMoveValid(forRightElf piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        if piece.color == .black{
            if dest.column < piece.col{
                return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
            }
        } else { //if piece.color == .white{
            if dest.column > piece.col{
                return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
            }
        }
        return false
    }
    
    func isMoveValid(forGhostQueen piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if !(isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)){
            return false
        }
        //the piece can't attack
        if board[dest.row][dest.column].type == .dummy {
            return true
        } else{
            return false
        }
    }
    
    func isMoveValid(forManticore piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if !piece.isMovementAppropriate(toIndex: dest){
            return false
        }
        //close range, can attack or move
        if isMoveValid(forKing: piece, toIndex: dest){
            return true
        } else { //can't attack but can move
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forBombard piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if !piece.isMovementAppropriate(toIndex: dest){
            return false
        }
        //close range, can move but not attack
        if isMoveValid(forKing: piece, toIndex: dest){
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        } else { //can attack or move
            return true
        }
        return false
    }
    
    //ice dragon moves like a rook and attacks like a bishop
    func isMoveValid(forIceDragon piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if !isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest){
            return false
        }
        //bishop move, attack
        if piece.checkBishop(dest: dest){
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
        }
        //rook move, move
        if piece.checkRook(dest: dest){
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forFireDragon piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if !isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest){
            return false
        }
        //bishop move, move
        if piece.checkBishop(dest: dest){
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        }
        //rook move, attack
        if piece.checkRook(dest: dest){
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forShip piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false{
            return false
        }
        if dest.row > piece.row{
            var testRow = dest.row
            while testRow! > piece.row{
                if board[testRow!][dest.column].type != .dummy{
                    return false
                }
                testRow = testRow! - 1
            }
            return true
        } else {//if dest.row < piece.row{
            var testRow = dest.row
            while testRow! < piece.row{
                if board[testRow!][dest.column].type != .dummy{
                    return false
                }
                testRow = testRow! + 1
            }
            return true
        }
    }
    
    func isMoveValid(forBasilisk piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        if piece.isMovementAppropriate(toIndex: dest) == false{
            return false
        }
        if dest.row == piece.row{
            return isMoveValid(forRookOrBishopOrQueen: piece, toIndex: dest)
        } else {
            return isMoveValid(forKing: piece, toIndex: dest)
        }
    }
    
    func isMoveValid(forGriffin piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false{
            return false
        }
        if dest.column == (piece.col + 1) || dest.column == (piece.col - 1){//vertical move
            return isMoveValid(forShip: piece, toIndex: dest)
        } else {//horizontal move
            if dest.column > piece.col{
                var testCol = dest.column
                while testCol! > piece.col{
                    if board[dest.row][testCol!].type != .dummy{
                        return false
                    }
                    testCol = testCol! - 1
                }
                return true
            } else {//if dest.row < piece.row{
                var testCol = dest.column
                while testCol! < piece.col{
                    if board[dest.row][testCol!].type != .dummy{
                        return false
                    }
                    testCol = testCol! + 1
                }
                return true
            }
        }
    }
    
    func isMoveValid(forFootSoldier piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        //if the move is to a different column (lateral)
        //the footSoldier can move here but not attack
        if piece.col != dest.column{
            //since we check elsewhere to avoid attacking friendly pieces, we only need to check if the space is empty
            if !(board[dest.row][dest.column].type == .dummy){
                return true
            }
            
        } else { //vertical move, can move here but not attack
            if board[dest.row][dest.column].type == .dummy{
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forGargoyle piece: ChessPiece, toIndex dest: BoardIndex) -> Bool{
        if piece.isMovementAppropriate(toIndex: dest) == false{
            return false
        }
        //can't move unless attacking
        if board[dest.row][dest.column].type == .dummy{
            return false
        }
        return true
    }
    
    func isMoveValid(forRookOrBishopOrQueen piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        //NSLog("Piece type: " + piece.symbol)
        if piece.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
        
        // Diagonal movement for either queen or bishop:
        // *** eg: from index (1,1) to index (3,3) would need to go through (1,1), (2,2), (3,3)
        // Straight movement for either queen or rook:
        // *** eg: from index (1,5) to (1,2) would need to go through (1,5), (1,4), (1,3), (1,2)
        
        // Get the movement directions in both rows and columns
        var rowDelta = 0
        if dest.row - piece.row != 0 {
            // this value will be either -1 or 1
            rowDelta = (dest.row - piece.row) / abs(dest.row - piece.row)
        }
        var colDelta = 0
        if dest.column - piece.col != 0 {
            colDelta = (dest.column - piece.col) / abs(dest.column - piece.col)
        }
        
        // make sure there are no pieces between itself and the destination cell
        var nextRow = piece.row + rowDelta
        var nextCol = piece.col + colDelta
        while nextRow != dest.row || nextCol != dest.column{
            NSLog("Place: \(nextRow), \(nextCol)")
            if !(board[nextRow][nextCol].type == .dummy) {
                return false
            }
            nextRow += rowDelta
            nextCol += colDelta
            if nextRow >= 8 || nextCol >= 8 || nextRow < 0 || nextCol < 0{
                break
            }
        }
        return true
    }
    
    //because of the unique movements of the dragonRider, it needs its own function
    func isMoveValid(forDragonRider piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        NSLog("DragonRider position: \(piece.row), \(piece.col)")
        NSLog("DragonRider destination: \(dest.row), \(dest.column)")
        if (dest.row - piece.row) == 6{//6,-3 or 6, 3
            if (dest.column - piece.col) == -3{//needs to go through 4,-2 and 2,-1
                if !(board[piece.row + 4][piece.col - 2].type == .dummy){
                    return false
                }
                if !(board[piece.row + 2][piece.col - 1].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 3{//needs to go through 4,2 and 2,1
                if !(board[piece.row + 4][piece.col + 2].type == .dummy){
                    return false
                }
                if !(board[piece.row + 2][piece.col + 1].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == 4{
            if (dest.column - piece.col) == -2{//needs to go through 2,-1
                if !(board[piece.row + 2][piece.col - 1].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 2{//needs to go through 2,1
                if !(board[piece.row + 2][piece.col + 1].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == 3{
            if (dest.column - piece.col) == -6{//needs to go through 2,-4 and 1,-2
                if !(board[piece.row + 2][piece.col - 4].type == .dummy){
                    return false
                }
                if !(board[piece.row + 1][piece.col - 2].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 6{//needs to go through 2,4 and 1,2
                if !(board[piece.row + 2][piece.col + 4].type == .dummy){
                    return false
                }
                if !(board[piece.row + 1][piece.col + 2].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == 2{
            if (dest.column - piece.col) == -4{//needs to go through 1,-2
                if !(board[piece.row + 1][piece.col - 2].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 4{//needs to go through 1,2
                if !(board[piece.row + 1][piece.col + 2].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == -2{
            if (dest.column - piece.col) == -4{//needs to go through -1,-2
                if !(board[piece.row - 1][piece.col - 2].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 4{//needs to go through -1,2
                if !(board[piece.row - 1][piece.col + 2].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == -3{
            if (dest.column - piece.col) == -6{//needs to go through -2,-4 and -1,-2
                if !(board[piece.row - 2][piece.col - 4].type == .dummy){
                    return false
                }
                if !(board[piece.row - 1][piece.col - 2].type == .dummy){
                    return false
                }
            } else if dest.column == 6{//needs to go through-1,2 and -2,4
                if !(board[piece.row - 2][piece.col + 4].type == .dummy){
                    return false
                }
                if !(board[piece.row - 1][piece.col + 2].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == -4{
            if (dest.column - piece.col) == -2{//needs to go through -2,-1
                if !(board[piece.row - 2][piece.col - 1].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 2{//needs to go through -2, 1
                if !(board[piece.row - 2][piece.col + 1].type == .dummy){
                    return false
                }
            }
        } else if (dest.row - piece.row) == -6{
            if (dest.column - piece.col) == -3{//needs to go through -4,-2, and -2,-1
                if !(board[piece.row - 4][piece.col - 2].type == .dummy){
                    return false
                }
                if !(board[piece.row - 2][piece.col - 1].type == .dummy){
                    return false
                }
            } else if (dest.column - piece.col) == 3{//needs to go through -4,2 and -2,1
                if !(board[piece.row - 4][piece.col + 2].type == .dummy){
                    return false
                }
                if !(board[piece.row - 2][piece.col + 1].type == .dummy){
                    return false
                }
            }
        }
        return true
    }
    
    func isMoveValid(forKing king: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        if king.isMovementAppropriate(toIndex: dest) == false {
            return false
        }
//
//        if isAnotherKing(atIndex: dest, forKing: king) {
//            return false
//        }
        
        return true
    }
    
    /// called from getPossibleMoves and when move made
    private func isMoveTwoCellsOver(forKing king: ChessPiece, move: BoardIndex) -> Bool {
        let colDelta = abs(king.col - move.column)
        return colDelta == 2
    }
    
    /// called from getPossibleMoves only
    private func isRookNext(toKing king: ChessPiece, forMove move: BoardIndex) -> Bool {
        if king.color == .white {
            //if move.row == 0 && move.column == 6
            return move.row == 0 && move.column == 6 && board[move.row][move.column + 1].type == .rook
        } else if king.color == .black {
            return move.row == 7 && move.column == 6 && board[move.row][move.column + 1].type == .rook
        }
        return false
    }
    
    func canOpponentAttack(playerKing king: ChessPiece, ifMovedTo dest: BoardIndex) -> Bool {
        //print("inside canOpponentAttack(playerKing:)")
        let opponent: UIColor = king.color == .white ? .black : .white
        if opponent == .black && king.color == .white {
            //print("Checking if black opponent can attack white king")
        } else if opponent == .white && king.color == .black {
            //print("Checking if white opponent can attack black king")
        }
        for row in 0...7 {
            for col in 0...7 {
                let piece = board[row][col]
                if piece.color == opponent {
                    if piece.type == .bishop && piece.color == .black {
                        print("Checking black bishop!!!!!!!")
                    }
                    //print("Can \(piece.printInfo()) attack king????????")
                    if isMoveLegal(forPiece: piece, toIndex: dest, considerOwnPiece: false) {
                        //print("Can \(piece.printInfo()) attack king is true")
                        return true
                    }
                    
                    
                }
            }
        }
        return false
    }
    
    private func isAnotherKing(atIndex dest: BoardIndex, forKing king: ChessPiece) -> Bool {
        
        let opponentColor = king.color == UIColor.white ? UIColor.black : UIColor.white
        // Get other king's index
        var otherKingIndex: BoardIndex!
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].type == .king && board[row][col].color == opponentColor {
                    otherKingIndex = BoardIndex(row: row, column: col)
                    break
                }
            }
        }
        
        // compute absolute difference between the kings
        let rowDiff = abs(otherKingIndex.row - king.row)
        let colDiff = abs(otherKingIndex.column - king.col)
        if (rowDiff == 0 || rowDiff == 1) && (colDiff == 0 || colDiff == 1) {
            print("Another king is right there")
            return true
        }
        //print("Not near opponent")
        return false
        
    }
    
    /// Returns true if current player is under check, false otherwise
    func isPlayerUnderCheck(playerColor: UIColor) -> Bool {
        
        guard let playerKing = getKing(forColor: playerColor) else {
            print("Something is seriously wrong")
            return false
        }
        
        let opponentColor: UIColor = playerColor == .white ? .black : .white
        
        return isKingUnderUnderCheck(king: playerKing, byOpponent: opponentColor)
    }
    
    private func getKing(forColor color: UIColor) -> ChessPiece? {
        if color == .white {
            //print("Looking for white king")
        } else if color == .black {
            //print("looking for black king")
        }
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].type == .king && board[row][col].color == color {
                    return board[row][col]
                }
            }
        }
        // should never get here
        print("Did not find king. SERIOUS ISSUE!!")
        return nil
    }
    
    /// returns true if player's king is under check, false otherwise. Called by
    /// another function: isPlayerUnderCheck
    private func isKingUnderUnderCheck(king: ChessPiece, byOpponent color: UIColor) -> Bool {
        
        let kingIndex = BoardIndex(row: king.row, column: king.col)
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].color == color {
                    if isMoveLegal(forPiece: board[row][col], toIndex: kingIndex, considerOwnPiece: true) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// Simulates the move and returns true if making it will expose the player to a check
    func doesMoveExposeKingToCheck(playerPiece piece: ChessPiece, toIndex dest: BoardIndex) -> Bool {
        
        let opponent: UIColor = piece.color == UIColor.white ? .black : .white
        guard let playerKing = getKing(forColor: piece.color) else {
            print("Something wrong in doesMoveExposeKingToCheck. Logic error")
            return false
        }
        //print("Piece index before: \(piece.row), \(piece.col)")
        
        let kingIndex = BoardIndex(row: playerKing.row, column: playerKing.col)
        //print("King index: \(kingIndex.row), \(kingIndex.column)")
        // can opponent attack own king if player makes this move?
        for row in 0...7 {
            for col in 0...7 {
                
                // "place" piece at the destination it's actually trying to go
                let pieceBeingAttacked = board[dest.row][dest.column]
                board[dest.row][dest.column] = piece
                board[piece.row][piece.col] = ChessPiece(row: piece.row, column: piece.col, color: .clear, type: .dummy, player: playerColor)
                //print("Piece being attacked: \(pieceBeingAttacked.printInfo()) by \(piece.printInfo())")
                
                if board[row][col].color == opponent {
                    if isMoveLegal(forPiece: board[row][col], toIndex: kingIndex, considerOwnPiece: true) {
                        //print("\(board[row][col].symbol) can attack your king!")
                        // undo fake move
                        board[dest.row][dest.column] = pieceBeingAttacked
                        board[piece.row][piece.col] = piece
                        print("Move will expose king to check")
                        return true
                    }
                }
                
                // undo fake move
                board[dest.row][dest.column] = pieceBeingAttacked
                board[piece.row][piece.col] = piece
            }
        }
        
        return false
    }
    
    func printBoard() {
        print(String(repeating: "=", count: 40))
        for row in 0...7 {
            let bRow = board[row].map {$0.symbol}
            print(bRow)
        }
        print(String(repeating: "=", count: 40))
    }
    
    func isWinner(player color: UIColor, byMove move: BoardIndex) -> Bool {
        let blackKings = numKings(color: .black)
        let whiteKings = numKings(color: .white)
        if whiteKings <= 0 && blackKings > 0 {
            if color == .black{
                return true
            }
        }
        if blackKings <= 0 && whiteKings > 0{
            if color == .white{
                return true
            }
        }
        return false
    }
    
    func numKings(color: UIColor) -> Int {
        var numKings = 0
        //iterate through pieces of each color
        let allPieces = getAllPieces(forPlayer: color)
        for piece in allPieces {
            if piece.type == .king || piece.type == .superKing{
                numKings = numKings + 1
            }
        }
        return numKings
    }
    
    func canPlayerEscapeCheck(player: UIColor, fromAttackingPiece attacker: ChessPiece) -> Bool {
        
        guard let playerKing = getKing(forColor: player) else {
            print("canPlayerEscapeCheck SERIOUS ERROR")
            return false
        }
        for row in 0...7 {
            for col in 0...7 {
                let piece = board[row][col]
                let dest = BoardIndex(row: piece.row, column: piece.col)
                // if it's one of the player's pieces
                if piece.color == player {
                    let possibleMoves = getPossibleMoves(forPiece: piece)
                    // simulate every possible move and see if it ends check
                    for move in possibleMoves {
                        if canMove(move: move, takeOutChessPiece: attacker) || canMove(fromIndex: dest, toIndex: move, blockCheckBy: attacker, forKing: playerKing) {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func canMove(move: BoardIndex, takeOutChessPiece piece: ChessPiece) -> Bool {
        //print("Can take out attacking piece")
        return move.row == piece.row && move.column == piece.col
    }
    
    func canMove(fromIndex source: BoardIndex, toIndex dest: BoardIndex, blockCheckBy piece: ChessPiece, forKing king: ChessPiece) -> Bool {
        
        let opponent: UIColor = king.color == .white ? .black : .white
        let movingPiece = board[source.row][source.column]
        board[dest.row][dest.column] = movingPiece
        board[source.row][source.column] = ChessPiece(row: 0, column: 0, color: .clear, type: .dummy, player: playerColor)
        movingPiece.col = dest.column
        movingPiece.row = dest.row
        
        if !isKingUnderUnderCheck(king: king, byOpponent: opponent) {
            // undo fake move
            board[source.row][source.column] = movingPiece
            board[dest.row][dest.column] = ChessPiece(row: dest.row, column: dest.column, color: .clear, type: .dummy, player: playerColor)
            movingPiece.row = source.row
            movingPiece.col = source.column
            //print("Can block check")
            return true
        }
        
        // undo fake move
        board[source.row][source.column] = movingPiece
        board[dest.row][dest.column] = ChessPiece(row: dest.row, column: dest.column, color: .clear, type: .dummy, player: playerColor)
        movingPiece.row = source.row
        movingPiece.col = source.column
        
        return false
    }
    
    /// Called after the passed in player made a move
    private func isGameTie(withCurrentPlayer player: UIColor) -> Bool {
        // TODO: Add a more exhuastive list of draw possibilities
        
        // if only kings remain game is tied
        if onlyKingsLeft() {
            print("Only 2 kings left")
            return true
        }
        // or draw if opponent not in check and has no possible moves
        var movesLeft = false
        let opponent: UIColor = player == .white ? .black : .white
        let opponentPieces = getAllPieces(forPlayer: opponent)
        for piece in opponentPieces {
            if getPossibleMoves(forPiece: piece).count > 0 {
                movesLeft = true
            }
        }
        return !movesLeft
    }
    
    /// A helper function called from isGameTie(_:)
    private func getAllPieces(forPlayer player: UIColor) -> [ChessPiece] {
        var playerPieces = [ChessPiece]()
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].color == player {
                    playerPieces.append(board[row][col])
                }
            }
        }
        return playerPieces
    }
    
    /// A helper function called from isGameTie(_:)
    private func onlyKingsLeft() -> Bool {
        var count = 0
        for row in 0...7 {
            for col in 0...7 {
                if board[row][col].type != .dummy {
                    count += 1
                }
                if count > 2 {
                    return false
                }
            }
        }
        return true
    }
    
    /// Returns true if a pawn is at the end of the board
    private func doesPawnNeedPromotion(pawn: ChessPiece) -> Bool {
        return pawn.type == .pawn && (pawn.row == 0 || pawn.row == 7)
    }
    
    /// Promote the pawn to the passed in the piece type. Called from VC
    func promote(pawn: ChessPiece, intoPiece piece: ChessPiece) {
        board[pawn.row][pawn.col] = piece
        delegate?.boardUpdated()
    }
    
}



