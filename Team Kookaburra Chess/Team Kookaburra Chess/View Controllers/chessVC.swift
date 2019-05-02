//
//  chessVC.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 3/18/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//
//  Originally created by Mikael Mukhsikaroyan on 11/1/16.
//  Used and modified under MIT License


import UIKit

class ChessVC: UIViewController {
    
    var playerColor: UIColor = .white
    var chessBoard = ChessBoard(playerColor: .white)
    var boardCells = [[BoardCell]]()
    var pieceBeingMoved: ChessPiece? = nil
    var possibleMoves = [BoardIndex]()
    var playerTurn = UIColor.white
    var whiteFormation = [[BoardCell]]()
    var blackFormation = [[BoardCell]]()
    var currentPiece = ChessPiece(row: -1, column: -1, color: .clear, type: .dummy, player: .black)
    
    let turnLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    let checkLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .red
        return l
    }()
    
    lazy var restartButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Restart Game", for: [])
        b.setTitleColor(.white, for: [])
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.addTarget(self, action: #selector(restartPressed(sender:)), for: .touchUpInside)
        return b
    }()
    
    lazy var menuButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Main Menu", for: [])
        b.setTitleColor(.white, for: [])
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.addTarget(self, action: #selector(restartPressed(sender:)), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent
        
        chessBoard.delegate = self
        drawBoard()
        setupViews()
        //print("White Formation: \(whiteFormation)")
        //print("Black Formation: \(blackFormation)")
    }
    
    func drawBoard() {
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
        boardCells = Array(repeating: oneRow, count: 8)
        chessBoard.takeFormations(black: blackFormation, white: whiteFormation)
        let cellDimension = (view.frame.size.width - 0) / 8
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 100
        for row in 0...7 {
            var actualRow = 0
            var actualCol = 0
            yOffset = (CGFloat(row) * cellDimension) + 80
            xOffset = 50
            for col in 0...7 {
                if playerColor == .white{
                    actualRow = row
                    actualCol = col
                } else {
                    actualRow = 7 - row
                    actualCol = 7 - col
                }
                xOffset = (CGFloat(col) * cellDimension) + 0
                
                let piece = chessBoard.board[actualRow][actualCol]
                let cell = BoardCell(row: actualRow, column: actualCol, piece: piece, color: .white)
                cell.delegate = self
                boardCells[actualRow][actualCol] = cell
                
                view.addSubview(cell)
                cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                    cell.color = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
                } else {
                    cell.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                }
                // set the color
                cell.removeHighlighting()
            }
        }
        updateLabel()
    }
    
    func setupViews() {
        
        view.addSubview(restartButton)
        restartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        restartButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        view.addSubview(menuButton)
        menuButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        menuButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(turnLabel)
        turnLabel.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -10).isActive = true
        turnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(checkLabel)
        checkLabel.bottomAnchor.constraint(equalTo: turnLabel.topAnchor, constant: -10).isActive = true
        checkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func updateLabel() {
        let color = playerTurn == .white ? "White" : "Black"
        turnLabel.text = "\(color) player's turn"
    }
    
    func newGame(){
        self.drawBoard()
    }
    
    // MARK: - Actions
    
    @objc func restartPressed(sender: UIButton) {
        let ac = UIAlertController(title: "Restart", message: "Are you sure you want to restart the game?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.newGame()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
    }
    
}

extension ChessVC: BoardCellDelegate {
    
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int) {
        //print("Selected cell at: \(row), \(col)")
        //chessBoard.board[row][col].showPieceInfo()
        // Check if making a move (if had selected piece before)
        currentPiece = cell.piece
        if let movingPiece = pieceBeingMoved, movingPiece.color == playerTurn {
            let source = BoardIndex(row: movingPiece.row, column: movingPiece.col)
            let dest = BoardIndex(row: row, column: col)
            // check if selected one of possible moves, if so move there
            for move in possibleMoves {
                if move.row == row && move.column == col {
                    
                    //print(chessBoard.board[cell.row][cell.column].symbol)
                    chessBoard.move(chessPiece: movingPiece, fromIndex: source, toIndex: dest)
                    //print(chessBoard.board[cell.row][cell.column].symbol)
                    //drawBoard()
                    
                    pieceBeingMoved = nil
                    playerTurn = playerTurn == .white ? .black : .white
//                    if chessBoard.isPlayerUnderCheck(playerColor: playerTurn) {
//                        checkLabel.text = "You are in check"
//                    } else {
//                        checkLabel.text = ""
//                    }
                    updateLabel()
                    //print("The old cell now holds: \(cell.piece.symbol)")
                    return
                }
            }
            if !movingPiece.isMovementAppropriate(toIndex: dest) || chessBoard.isAttackingOwnPiece(attackingPiece: movingPiece, atIndex: dest){ //selcting a space that the piece can't move to
                if cell.piece.color == playerTurn{
                    boardCells[movingPiece.row][movingPiece.col].removeHighlighting()
                    pieceBeingMoved = cell.piece
                    cell.backgroundColor = cell.hexStringToUIColor(hex:"6DAFFB")
                    
                    // reset the possible moves
                    removeHighlights()
                    possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                    highlightPossibleMoves()
                } else if cell.piece.color != playerTurn{
                    // remove the old selected cell coloring and set new piece
                    boardCells[movingPiece.row][movingPiece.col].removeHighlighting()
                    
                    pieceBeingMoved = cell.piece
                    cell.backgroundColor = UIColor.red
                    
                    // reset the possible moves
                    removeHighlights()
                    possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                    highlightEnemyMoves()
                }
            }
//            if chessBoard.isAttackingOwnPiece(attackingPiece: movingPiece, atIndex: dest) && cell.piece.color == playerTurn {
//                // remove the old selected cell coloring and set new piece
//                boardCells[movingPiece.row][movingPiece.col].removeHighlighting()
//                pieceBeingMoved = cell.piece
//                cell.backgroundColor = cell.hexStringToUIColor(hex:"6DAFFB")
//
//                // reset the possible moves
//                removeHighlights()
//                possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
//                highlightPossibleMoves()
//            } else if chessBoard.isAttackingOwnPiece(attackingPiece: movingPiece, atIndex: dest) && cell.piece.color != playerTurn {
//                // remove the old selected cell coloring and set new piece
//                boardCells[movingPiece.row][movingPiece.col].removeHighlighting()
//                pieceBeingMoved = cell.piece
//                cell.backgroundColor = UIColor.red
//
//                // reset the possible moves
//                removeHighlights()
//                possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
//            }
        } else { // not already moving piece
            if cell.piece.color == playerTurn {
                clearRedCells()
                // selected another piece to play
                cell.backgroundColor = cell.hexStringToUIColor(hex:"6DAFFB")
                pieceBeingMoved = cell.piece
                removeHighlights()
                possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                highlightPossibleMoves()
            } else if cell.piece.color != playerTurn && cell.piece.type != .dummy{
                clearRedCells()
                //selected opponent Piece
                cell.backgroundColor = .red
                pieceBeingMoved = cell.piece
                removeHighlights()
                possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                highlightEnemyMoves()
            }
        }
        checkLabel.text = displayInfo(piece: currentPiece)
        updateLabel()
        //print("The old cell now holds: \(cell.piece.symbol)")
        //print(chessBoard.board[cell.row][cell.column])
    }
    
    func highlightPossibleMoves() {
        for move in possibleMoves {
            //print(move.row)
            boardCells[move.row][move.column].setAsPossibleLocation()
        }
    }
    
    func highlightEnemyMoves(){
        for move in possibleMoves{
            boardCells[move.row][move.column].setAsEnemyLocation()
        }
    }
    
    func removeHighlights() {
        for move in possibleMoves {
            //print(move.row)
            boardCells[move.row][move.column].removeHighlighting()
        }
    }
    
    //This shouldn't be necessary, but for some reason the game was keeping red cells up even when you clicked on other pieces.
    func clearRedCells(){
        var currentCell = boardCells[0][0]
        for row in 0...7{
            for col in 0...7{
                currentCell = boardCells[row][col]
                if currentCell.backgroundColor == .red {
                    currentCell.removeHighlighting()
                }
            }
        }
    }
    
}

extension ChessVC: ChessBoardDelegate {
    
    func boardUpdated() {
        //print("Board updated")
        for row in 0...7 {
            for col in 0...7 {
                let cell = boardCells[row][col]
                let piece = chessBoard.board[row][col]
                cell.configureCell(forPiece: piece)
            }
        }
        
    }
    
    func gameOver(withWinner winner: UIColor) {
        if winner == .white {
            showGameOver(message: "White player won!")
        } else if winner == .black {
            showGameOver(message: "Black player won!")
        }
    }
    
    func gameTied() {
        print("GAME TIED!!!")
        showGameOver(message: "Game Tied!")
    }
    
    func promote(pawn: ChessPiece) {
        showPawnPromotionAlert(forPawn: pawn)
    }
    
    // MARK: Alerts
    
    func showGameOver(message: String) {
        let ac = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.newGame()
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: { action in
            
            print("Too bad. That's all we can do right now. Haven't added another scene yet")
            //self.chessBoard.startNewGame()
        })
        
        ac.addAction(okAction)
        ac.addAction(noAction)
        present(ac, animated: true, completion: nil)
    }
    
    func displayInfo(piece: ChessPiece) -> String{
        print("Displaying info on check label from piece: \(piece)")
        if piece.color == playerTurn{
            switch piece.type{
            case .dummy:
                return "An empty space"
            case .unicorn:
                return "Your Unicorn"
            case .superKing:
                return "Your Superking"
            case .griffin:
                return "Your Griffin"
            case .king:
                return "Your King"
            case .queen:
                return "Your Queen"
            case .mage:
                return "Your Mage"
            case .centaur:
                return "Your Centaur"
            case .dragonRider:
                return "Your Dragon Rider"
            case .bombard:
                return "Your Bombard"
            case .manticore:
                return "Your Manticore"
            case .ghostQueen:
                return "Your Ghost Queen"
            case .rook:
                return "Your Rook"
            case .knight:
                return "Your Knight"
            case .bishop:
                return "Your Bishop"
            case .basilisk:
                return "Your Basilisk"
            case .fireDragon:
                return "Your Fire Dragon"
            case .iceDragon:
                return "Your Ice Dragon"
            case .minotaur:
                return "Your Minotaur"
            case .monopod:
                return "Your Monopod"
            case .ship:
                return "Your Ship"
            case .ballista:
                return "Your Ballista"
            case .batteringRam:
                return "Your Battering Ram"
            case .trebuchet:
                return "Your Trebuchet"
            case .leftElf:
                return "Your Left Handed Elf"
            case .rightElf:
                return "Your Right Handed Elf"
            case .camel:
                return "Your Camel"
            case .scout:
                return "Your Scout"
            case .ogre:
                return "Your Ogre"
            case .orcWarrior:
                return "Your Orc Warrior"
            case .elephant:
                return "Your Elephant"
            case .manAtArms:
                return "Your Man at Arms"
            case .swordsman:
                return "Your Swordsman"
            case .pikeman:
                return "Your Pikeman"
            case .archer:
                return "Your Archer"
            case .royalGuard:
                return "Your Royal Guard"
            case .demon:
                return "Your Demon"
            case .pawn:
                return "Your Pawn"
            case .monk:
                return "Your Monk"
            case .dwarf:
                return "Your Dwarf"
            case .gargoyle:
                return "Your Gargoyle"
            case .goblin:
                return "Your Goblin"
            case .footSoldier:
                return "Your Footsoldier"
            @unknown default:
                return "Did you hack this game?"
            }
        } else {
            switch piece.type{
            case .dummy:
                return "An empty space"
            case .unicorn:
                return "Enemy Unicorn"
            case .superKing:
                return "Enemy Superking"
            case .griffin:
                return "Enemy Griffin"
            case .king:
                return "Enemy King"
            case .queen:
                return "Enemy Queen"
            case .mage:
                return "Enemy Mage"
            case .centaur:
                return "Enemy Centaur"
            case .dragonRider:
                return "Enemy Dragon Rider"
            case .bombard:
                return "Enemy Bombard"
            case .manticore:
                return "Enemy Manticore"
            case .ghostQueen:
                return "Enemy Ghost Queen"
            case .rook:
                return "Enemy Rook"
            case .knight:
                return "Enemy Knight"
            case .bishop:
                return "Enemy Bishop"
            case .basilisk:
                return "Enemy Basilisk"
            case .fireDragon:
                return "Enemy Fire Dragon"
            case .iceDragon:
                return "Enemy Ice Dragon"
            case .minotaur:
                return "Enemy Minotaur"
            case .monopod:
                return "Enemy Monopod"
            case .ship:
                return "Enemy Ship"
            case .ballista:
                return "Enemy Ballista"
            case .batteringRam:
                return "Enemy Battering Ram"
            case .trebuchet:
                return "Enemy Trebuchet"
            case .leftElf:
                return "Enemy Left Handed Elf"
            case .rightElf:
                return "Enemy Right Handed Elf"
            case .camel:
                return "Enemy Camel"
            case .scout:
                return "Enemy Scout"
            case .ogre:
                return "Enemy Ogre"
            case .orcWarrior:
                return "Enemy Orc Warrior"
            case .elephant:
                return "Enemy Elephant"
            case .manAtArms:
                return "Enemy Man at Arms"
            case .swordsman:
                return "Enemy Swordsman"
            case .pikeman:
                return "Enemy Pikeman"
            case .archer:
                return "Enemy Archer"
            case .royalGuard:
                return "Enemy Royal Guard"
            case .demon:
                return "Enemy Demon"
            case .pawn:
                return "Enemy Pawn"
            case .monk:
                return "Enemy Monk"
            case .dwarf:
                return "Enemy Dwarf"
            case .gargoyle:
                return "Enemy Gargoyle"
            case .goblin:
                return "Enemy Goblin"
            case .footSoldier:
                return "Enemy Footsoldier"
            @unknown default:
                return "Did you hack this game?"
            }
        }
        return ""
    }
    
    func showPawnPromotionAlert(forPawn pawn: ChessPiece) {
        let ac = UIAlertController(title: "Promote Piece", message: "Please choose the piece you want to promote your piece into", preferredStyle: .actionSheet)
        let dragonRider = UIAlertAction(title: "Dragon Rider", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: ChessPiece(row: pawn.row, column: pawn.col, color: pawn.color, type: .dragonRider, player: self.playerColor))
        })
        let unicorn = UIAlertAction(title: "Unicorn", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: ChessPiece(row: pawn.row, column: pawn.col, color: pawn.color, type: .unicorn, player: self.playerColor))
        })
        let queen = UIAlertAction(title: "Queen", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: ChessPiece(row: pawn.row, column: pawn.col, color: pawn.color, type: .queen, player: self.playerColor))
        })
        let griffin = UIAlertAction(title: "Griffin", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: ChessPiece(row: pawn.row, column: pawn.col, color: pawn.color, type: .griffin, player: self.playerColor))
        })
        let bombard = UIAlertAction(title: "Bombard", style: .default, handler: { _ in
            self.chessBoard.promote(pawn: pawn, intoPiece: ChessPiece(row: pawn.row, column: pawn.col, color: pawn.color, type: .bombard, player: self.playerColor))
        })
        ac.addAction(queen)
        ac.addAction(dragonRider)
        ac.addAction(unicorn)
        ac.addAction(griffin)
        ac.addAction(bombard)
        present(ac, animated: true, completion: nil)
    }
    
}