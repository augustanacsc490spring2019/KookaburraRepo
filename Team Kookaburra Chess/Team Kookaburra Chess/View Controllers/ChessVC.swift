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
    //var boardCells = [[BoardCell]]()
    var boardCells = Array(repeating: Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: UIColor.white), color: .clear), count: 8), count: 8)
    var pieceBeingMoved: ChessPiece? = nil
    var possibleMoves = [BoardIndex]()
    var possibleAttacks = [BoardIndex]()
    var playerTurn = UIColor.white
    //    var whiteFormation = [[BoardCell]]()
    //    var blackFormation = [[BoardCell]]()
    var currentPiece = ChessPiece(row: -1, column: -1, color: .clear, type: .dummy, player: .black)
    var isLocalMatch: Bool = true
    var model: GameModel
    var resetModel: GameModel //we load this in in the beginning and don't change it
    
    let turnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()
    
    lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        if self.isLocalMatch{
            button.setTitle("Restart Game", for: [])
        } else {
            button.setTitle("Forfeit Game", for: [])
        }
        button.setTitleColor(.white, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(restartPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("<", for: [])
        button.setTitleColor(.white, for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(menuPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    //from Nine Knights GameScene, which is an SKScene
    init(model: GameModel) {
        
        self.model = model
        self.resetModel = model
        
        super.init(nibName:nil , bundle:nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.model = GameModel()
        self.resetModel = GameModel()
        super.init(nibName:nil , bundle:nil)
        print("  fatalError(\"init(coder:) has not been implemented\")")
    }
    
    //     from anthony
    //    required init?(coder aDecoder: NSCoder) {
    //        self.pieceNamesArray = [[String]]()
    //        self.model = GameModel()
    //        self.isLocalMatch = true
    //        super.init(coder: aDecoder)
    //    }
    
    //    override func loadView() {
    //        print("ChessVC loadView called")
    //        checkIfPlacePiecesNeeded()
    //    }
    
    override func viewDidLoad() {
        print("ChessVC viewdidload called")
        //checkIfPlacePiecesNeeded()
        //        print ("isLocalMatch a viewDidLoad: \(isLocalMatch)")
        //        var isNewMatch: Bool = checkIsNewMatch()
        //        print("isnewMatch: \(isNewMatch)")
        //        if !isLocalMatch {//}&& checkIsNewMatch() {
        //            print("attempted segue to online place pieces")
        ////            let onlinePlacePieces = PlacePiecesViewController()
        ////            onlinePlacePieces.addStarterKing()
        ////            self.present(onlinePlacePieces, animated: true, completion: nil)
        //            self.performSegue(withIdentifier: "OnlinePlacePiecesSegue", sender: self)
        //            //Makes online players place pieces before can make moves
        //        }
        
        // if online match, reset board using self.model
        if (!isLocalMatch) {
            
            // copy pieces from self.model.piecesArray
            self.setFormationFromGameCenterModel()
            
            // set local player color and turn
            // TODO: could reference self.model directly and get rid of self.playColor and self.playerTurn
            // but that would mean putting localMatch into a local model
            self.playerColor = self.model.localPlayerUIColor()
            self.playerTurn = self.model.isWhiteTurn ? .white : .black
            
        } // not a local match
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent
        
        chessBoard.delegate = self
        drawBoard()
        setupViews()
        chessBoard.checkGameOver(color: playerTurn)
        //print("White Formation: \(whiteFormation)")
        //print("Black Formation: \(blackFormation)")
    }
    
    //probably don't need anymore
    //    func checkIfPlacePiecesNeeded(){
    //        print ("isLocalMatch: \(isLocalMatch)")
    //        var isNewMatch: Bool = checkIsNewMatch()
    //        print("isnewMatch: \(isNewMatch)")
    //        if !isLocalMatch {//}&& checkIsNewMatch() {
    //            print("attempted segue to online place pieces")
    //            //            let onlinePlacePieces = PlacePiecesViewController()
    //            //            onlinePlacePieces.addStarterKing()
    //            //            self.present(onlinePlacePieces, animated: true, completion: nil)
    //            self.performSegue(withIdentifier: "OnlinePlacePiecesSegue", sender: self)
    //            //Makes online players place pieces before can make moves
    //        }
    //    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if (segue.identifier == "OnlinePlacePiecesSegue") {
    //            print("prepare for OnlinePlacePiecesSegue called")
    //            let vc = segue.destination as! PlacePiecesViewController
    //            //vc.playerColor = playerColor
    //            vc.boardCells = boardCells
    //        }
    //    }
    
    func drawBoard() {
        //print("chessVC drawBoard called")
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
        boardCells = Array(repeating: oneRow, count: 8)
        //print("black formation: \(blackFormation)")
        //print("white formation: \(whiteFormation)")
        //chessBoard.takeFormations(black: blackFormation, white: whiteFormation)
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
                //print("drawBoard row: \(row), col: \(col), piece: \(piece.symbol)")
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
        menuButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -170).isActive = true
        menuButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(turnLabel)
        turnLabel.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -10).isActive = true
        turnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(checkLabel)
        checkLabel.bottomAnchor.constraint(equalTo: turnLabel.topAnchor, constant: -10).isActive = true
        checkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func updateLabel() {
        if isLocalMatch{
        let color = playerTurn == .white ? "White" : "Black"
        turnLabel.text = "\(color) player's turn"
        } else {
            if self.model.localPlayerUIColor() == playerTurn{
                turnLabel.text = "Your turn"
            } else {
                //let oppID = getOppIDfromModel()
                //turnLabel.text = "\(oppID)'s turn, you can't move any pieces"
                turnLabel.text = "Opponent's turn, you can't move any pieces"
            }
        }
    }
    
//    func getOppIDfromModel() -> String {
//        if self.model.playerIDs[0] == gc.GKLocalPlayer.local
//    }
    
    func newGame(){
        self.drawBoard()
        self.getFormationFromModel()
    }
    
    func restartGame(){
        self.drawBoard()
        self.resetFormationFromModel()
    }
    
    func fofeit(){
        if playerColor == .white{
            gameOver(withWinner: .black)
        } else {
            gameOver(withWinner: .white)
        }
        //TODO: send this information to the model
    }
    
    func getFormationFromModel(){
        //clear the board in case we're restarting a game, not necessary at the start of games
        //TODO: add isRestart parameter so this isn't called at the beginning of a game
        for row in 0...7{
            for col in 0...7{
                let cell = boardCells[row][col]
                cell.piece.type = .dummy
                cell.piece.setupSymbol()
                chessBoard.board[row][col].type = .dummy
                chessBoard.board[row][col].setupSymbol()
            }
        }
        for pieceInfo in model.piecesArray{
            let piece = ChessPiece(row: pieceInfo.row, column: pieceInfo.col, color: pieceInfo.uiColor, type: pieceInfo.type, player: pieceInfo.uiColor)
            piece.setupSymbol()
            if piece.type != .dummy{
                print("There should really be a piece here somewhere")
            }
            boardCells[pieceInfo.row][pieceInfo.col].piece = piece
            chessBoard.board[pieceInfo.row][pieceInfo.col] = piece
        }
    }
    
    func resetFormationFromModel(){
        
        //clear the board in case we're restarting a game, not necessary at the start of games
        //TODO: add isRestart parameter so this isn't called at the beginning of a game
        
        setFormationFromModel(aModel:self.resetModel)
        
    }
    
    func setFormationFromGameCenterModel() {
        
        setFormationFromModel(aModel:self.model)
        
        
    }
    
    func setFormationFromModel(aModel: GameModel){
        // set the pieces on the board using the gamemodel passed to us from gamecenter
        for row in 0...7{
            for col in 0...7 {
                
                boardCells[row][col].piece.type =  .dummy
                boardCells[row][col].piece.setupSymbol()
                boardCells[row][col].row = row
                boardCells[row][col].col = col
                
                chessBoard.board[row][col].type = .dummy
                chessBoard.board[row][col].setupSymbol()
            }
        }
        for pieceInfo in aModel.piecesArray{
            
            
            let piece = ChessPiece(pieceInfo: pieceInfo)
            if piece.type != .dummy{
                print("There should really be a piece here somewhere")
            }
            boardCells[pieceInfo.row][pieceInfo.col].row = pieceInfo.row
            boardCells[pieceInfo.row][pieceInfo.col].col = pieceInfo.col
            
            boardCells[pieceInfo.row][pieceInfo.col].piece = piece
            chessBoard.board[pieceInfo.row][pieceInfo.col] = piece
        }
        
    }
    
    func setGameCenterModelFromFormation() {
        
        setModelFromFormation(aModel: &self.model);
        
    }
    
    func setModelFromFormation( aModel: inout GameModel) {
        
        aModel.piecesArray.removeAll()
        for r in 0...7 {
            for c in 0...7 {
                let pieceBasicInfo = boardCells[r][c].piece.getBasicInfo()
                aModel.piecesArray.append(pieceBasicInfo)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc func restartPressed(sender: UIButton) {
        if isLocalMatch{
            presentRestart()
        } else {
            presentForfeit()
        }
    }
    
    func presentRestart(){
        let ac = UIAlertController(title: "Restart", message: "Are you sure you want to restart the game?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.restartGame()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
    }
    
    func presentForfeit() {
        let ac = UIAlertController(title: "Forfeit", message: "Are you sure you want to forfeit the game?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Forfeit", style: .default, handler: { action in
            self.fofeit()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func menuPressed(sender: UIButton) {
        if isLocalMatch{
            let ac = UIAlertController(title: "Main Menu", message: "Are you sure you want to end the game?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.goToMain()
            })
            let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(yes)
            ac.addAction(no)
            present(ac, animated: true, completion: nil)
        } else {
            goToMain()
        }
        
    }
    
    func goToMain(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "OpeningScreen") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension ChessVC: BoardCellDelegate {
    
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int) {
        //print("Selected cell at: \(row), \(col)")
        //chessBoard.board[row][col].showPieceInfo()
        // Check if making a move (if had selected piece before)
        clearRedCells()
        removeHighlights()
        currentPiece = cell.piece
        if let movingPiece = pieceBeingMoved, movingPiece.color == playerTurn {
            let source = BoardIndex(row: movingPiece.row, column: movingPiece.col)
            let dest = BoardIndex(row: row, column: col)
            // check if selected one of possible moves, if so move there
            for move in possibleMoves {
                if move.row == row && move.col == col {
                    
                    if (!isLocalMatch) {
                        
                        
                        // TODO:  call match.canTakeTurnForCurrentMatch instead?
                        
                        let localPlayerTurn = (self.model.isWhiteTurn == (playerColor == .white))
                        
                        if (localPlayerTurn && chessBoard.canPlayerTakeTurn(color: self.model.localPlayerUIColor())) {
                            
                            chessBoard.move(chessPiece: movingPiece, fromIndex: source, toIndex: dest)
                            
                            pieceBeingMoved = nil
                            
                            endGameCenterTurn()
                            
                            
                        }
                        
                    }
                        
                        
                    else { // is a local match
                        
                        
                        chessBoard.move(chessPiece: movingPiece, fromIndex: source, toIndex: dest)
                        
                        pieceBeingMoved = nil
                        
                        if playerTurn == .white{
                            if chessBoard.canPlayerTakeTurn(color: .black) {
                                endLocalTurn()
                            }
                        } else {//if playerTurn == .black
                            if chessBoard.canPlayerTakeTurn(color: .white){
                                endLocalTurn()
                            }
                        }
                        
                    }
                    
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
                    possibleAttacks = chessBoard.getPossibleAttacks(forPiece: cell.piece, moves: possibleMoves)
                    highlightPossibleAttacks()
                } else if cell.piece.color != playerTurn{
                    // remove the old selected cell coloring and set new piece
                    boardCells[movingPiece.row][movingPiece.col].removeHighlighting()
                    
                    pieceBeingMoved = cell.piece
                    cell.backgroundColor = UIColor.red
                    
                    // reset the possible moves
                    removeHighlights()
                    possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
                    highlightEnemyMoves()
                    possibleAttacks = chessBoard.getPossibleAttacks(forPiece: cell.piece, moves: possibleMoves)
                    highlightPossibleAttacks()
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
            } else if cell.piece.color != playerTurn && cell.piece.type != .dummy{
                clearRedCells()
                //selected opponent Piece
                cell.backgroundColor = .red
                pieceBeingMoved = cell.piece
                removeHighlights()
            }
        }
        possibleMoves = chessBoard.getPossibleMoves(forPiece: cell.piece)
        if cell.piece.color == playerTurn{
            highlightPossibleMoves()
            cell.backgroundColor = cell.hexStringToUIColor(hex:"6DAFFB")
        } else {
            highlightEnemyMoves()
            cell.backgroundColor = .red
        }
        possibleAttacks = chessBoard.getPossibleAttacks(forPiece: cell.piece, moves: possibleMoves)
        highlightPossibleAttacks()
        checkLabel.text = displayInfo(piece: currentPiece)
        updateLabel()
        //print("The old cell now holds: \(cell.piece.symbol)")
        //print(chessBoard.board[cell.row][cell.column])
    }
    
    func endLocalTurn() {
        playerTurn = playerTurn == .white ? .black : .white
        
        //        if chessBoard.isPlayerUnderCheck(playerColor: playerTurn) {
        //            checkLabel.text = "You are in check"
        //        } else {
        //            checkLabel.text = ""
        //        }
        
        updateLabel()
    }
    
    func endGameCenterTurn(){
        
        self.model.updateTurn()
        
        //        if chessBoard.isPlayerUnderCheck(playerColor: playerTurn) {
        //            checkLabel.text = "You are in check"
        //        } else {
        //            checkLabel.text = ""
        //        }
        updateLabel()
        
        // copy state of chess board into gamecenter model self.model.piecesArray
        // switch the current player by inverting self.model.isWhiteTurn
        
        if (!isLocalMatch) {
            
            setGameCenterModelFromFormation();
            
            self.model.isWhiteTurn = !self.model.isWhiteTurn;
            
            GameCenterHelper.helper.endTurn(self.model) { error in
                defer {
                    print("self.isSendingTurn = false")
                }
                
                if let e = error {
                    print("Error ending turn: \(e.localizedDescription)")
                    return
                }
                
                // self.returnToMenu()
            }
        }
    }
    
    func highlightPossibleMoves() {
        for move in possibleMoves {
            //print(move.row)
            boardCells[move.row][move.col].setAsPossibleLocation()
        }
    }
    
    func highlightEnemyMoves(){
        for move in possibleMoves{
            boardCells[move.row][move.col].setAsEnemyLocation()
        }
    }
    
    func highlightPossibleAttacks(){
        //print("possible attacks being highlighted")
        for move in possibleAttacks{
            boardCells[move.row][move.col].setAsBlocked()
        }
    }
    
    func removeHighlights() {
        for row in 0...7 {
            for column in 0...7{
                boardCells[row][column].removeHighlighting()
            }
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
        if isLocalMatch{
            presentLocalGameOver(message: message)
        } else {
            presentOnlineGameOver(message: message)
        }
    }
    
    func presentLocalGameOver(message: String){
        let ac = UIAlertController(title: "Game Over!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Restart", style: .default, handler: { action in
            self.newGame()
        })
        let noAction = UIAlertAction(title: "View Board", style: .default, handler: { action in
            
            print("Too bad. That's all we can do right now. Haven't added another scene yet")
            //self.chessBoard.startNewGame()
        })
        
        ac.addAction(okAction)
        ac.addAction(noAction)
        present(ac, animated: true, completion: nil)
    }
    
    func presentOnlineGameOver(message: String){
        let ac = UIAlertController(title: "Game Over!", message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "View Board", style: .default, handler: nil)
        ac.addAction(noAction)
        present(ac, animated: true, completion: nil)
    }
    
    func displayInfo(piece: ChessPiece) -> String{
        //print("Displaying info on check label from piece: \(piece)")
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
            case .boar:
                return "Your Boar"
            case .thunderChariot:
                return "Your Thunder Chariot"
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
            case .boar:
                return "Enemy Boar"
            case .thunderChariot:
                return "Enemy Thunder Chariot"
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
    
    //probably don't need anymore
    //    func checkIsNewMatch() -> Bool{
    //        var piecesPlacedTop: Bool = false
    //        var piecesPlacedBottom: Bool = false
    //        for row in 0...3{
    //            for col in 0 ... 7 {
    //                let cell = boardCells[row][col]
    //                if cell.piece.type != .dummy {
    //                    piecesPlacedTop = true
    //                }
    //            }
    //        }
    //        for row in 4...7{
    //            for col in 0 ... 7 {
    //                let cell = boardCells[row][col]
    //                if cell.piece.type != .dummy {
    //                    piecesPlacedBottom = true
    //                }
    //            }
    //        }
    //        let bothSetsPlaced: Bool = piecesPlacedTop && piecesPlacedBottom
    //        return !bothSetsPlaced
    //    }
}
