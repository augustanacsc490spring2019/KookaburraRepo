//
//  PlacePiecesViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit

class PlacePiecesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ChessBoardDelegate {
    //ChessBoard Delegate functions
    func boardUpdated() {
            //print("Board updated")
            for row in 0...2 {
                for col in 0...7 {
                    let cell = boardCells[row][col]
                    let piece = chessBoard.board[row][col]
                    cell.configureCell(forPiece: piece)
                }
            }
            
    }
    
    func gameOver(withWinner winner: UIColor) {
        //only here to fill protocol
    }
    
    func gameTied() {
        //only here to fill protocol
    }
    
    func promote(pawn: ChessPiece) {
       //only here to fill protocol
    }
    
    var playerColor: UIColor = .white
    var playerPoints: Int = 0
    var chessBoard = ChessBoard(playerColor: .white)
    var boardCells = [[BoardCell]]()
    var pieceBeingMoved: ChessPiece? = nil
    var possibleMoves = [BoardIndex]()
    var playerTurn = UIColor.white
    var pickerData: [String] = [String]()
    var highlightedCell: BoardCell = BoardCell(row: 0, column: 0, piece: ChessPiece(row: 0, column: 0, color: .clear, type: .dummy, player: .white), color: .white)
    var pickerString: String = ""
    var chosenPieces = [[ChessPiece]]()
    
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var quantLabel: UILabel!
    @IBOutlet weak var pointsRemaining: UILabel!
    @IBOutlet weak var yourColor: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var pieceCost: UILabel!
    @IBOutlet weak var piecePicture: UIImageView!
    @IBOutlet weak var pieceInfo: UILabel!
    @IBOutlet weak var piecePicker: UIPickerView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setLabels()
        drawBoard()
        piecePicker.delegate = self
        piecePicker.dataSource = self
        pickerData = ["Empty", "King", "Pawn", "Griffin"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLabels(){
        quantLabel.text = "/450"
        pointsRemaining.text = "Points spent: \(playerPoints)"
        if playerColor == .white{
            yourColor.text = "You are white this match"
        } else {
            yourColor.text = "You are black this match"
        }
        tipLabel.text = "Select a space and start placing pieces!"
        pieceInfo.lineBreakMode = .byWordWrapping
        pieceInfo.numberOfLines = 0
        
    }
    
    func drawBoard(){
            let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
            var boardCells = Array(repeating: oneRow, count: 8)
            let cellDimension = (view.frame.size.width - 0) / 8
            var xOffset: CGFloat = 0
            var yOffset: CGFloat = 0
            for row in 0...2 {
                yOffset = (CGFloat(row) * cellDimension) + 200
                xOffset = 50
                for col in 0...7 {
                    xOffset = (CGFloat(col) * cellDimension) + 0
                    
                    let piece = chessBoard.board[row][col]
                    let cell = BoardCell(row: row, column: col, piece: piece, color: .white)
                    cell.delegate = self
                    boardCells[row][col] = cell
                   // NSLog("Board cells at row, col: \(boardCells[row][col])")
                    view.addSubview(cell)
                    cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                    if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                        cell.color = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
                    } else {
                        cell.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                    }
                    // set the color
                    cell.removeHighlighting()
                    //empty the cell
                    cell.piece.type = .dummy
                    boardCells[row][col] = cell
                }
            }
        }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) ->Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row]
    }
    
    func clearPieces(){
        for row in 0...2{
            for col in 0...7{
                let currentPiece = chessBoard.board[row][col]
                currentPiece.type = .dummy
                currentPiece.setupSymbol()
            }
        }
    }
    
    
    @IBAction func placeButtonPressed(_ sender: Any) {
        //check that for chess piece type
        var chosenPiece = getPiece(string: pickerString)
        //check if there are enough points to place the piece
        var cost = chosenPiece.summonCost
        if chosenPiece.type == .king{
            NSLog("All hail!")
            //if numKings() > 0{
            //cost = cost + 20
            //}
        }
        if (playerPoints + cost) > 450 {
            NSLog("Too many points spent")
            //change the tip label
            //show a notification, "you don't have enough points"
        } else{
            NSLog("check if the piece is illegally placed")
            //check if the piece is illegally placed
            if ((chosenPiece.type == .dragonRider) || (highlightedCell.row == 2)){
                if chosenPiece.type == .dragonRider && highlightedCell.row < 2{
                    NSLog("Dragonriders can only be in the back row")
                    //change the tip label
                    //show a notification, "piece can't be placed because of rule"
                } //else if highlightedCell.row == 2 && !secondRowFull(){
                //change the tip label
                //show a notification, "piece can't be placed because of rule"
                //}
            } else {//place the piece
                highlightedCell.piece.type = chosenPiece.type
                //add summon points
                playerPoints = playerPoints + highlightedCell.piece.summonCost
                pointsRemaining.text = "Points spent: \(playerPoints)"
                chosenPieces[highlightedCell.row][highlightedCell.column] = chosenPiece
                NSLog("chosen pieces: \(chosenPieces)")
            }
        }
        
        //if there's an issue, change the tip label
        //if not, place the piece
        
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        //put up an "are you sure?" popup
        let ac = UIAlertController(title: "Reset", message: "Are you sure you want to remove every piece?", preferredStyle: .alert)
        //if yes, clear all the pieces
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.clearPieces()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
        //if no, do nothing
    }
    
    @IBAction func readyButtonPressed(_ sender: Any) {
        //check if the player has at least one king
        //check if the player has used up enough points (at least 440)
        if playerPoints < 440{
            //if not, ask them if they're sure they want to ready up
            let ac = UIAlertController(title: "Points remaining", message: "You still have points to spend, ready anyway?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Ready!", style: .default, handler: { action in
                self.chessBoard.startNewGame()//start a new game, not this function
            })
            let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac.addAction(yes)
            ac.addAction(no)
            present(ac, animated: true, completion: nil)
        }
        //start the game with the current piece placement
    }
    
    //updates the screen when the uipicker changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSLog("Picker Changed")
        //get the string from the picker
        pickerString = pickerData[row]
        //compare that string to the piece types
        let piece = getPiece(string: pickerString)
        //assign the .png file to the UIImageview
        piece.setupSymbol()
        piecePicture.image = piece.symbolImage
        //assign info text to the info label
        pieceInfo.text = getInfo(piece: piece)
        //assign cost to the top label
        if piece.type == .king{
            //if numKings() > 0{
            //cost = cost + 20
            //}
        }
        pieceCost.text = "Cost: \(piece.summonCost) points"
    }
    
    func getPiece(string: String) -> ChessPiece {
        //NSLog("getting piece")
        var piece = ChessPiece(row: -1, column: -1, color: playerColor, type: .dummy, player: playerColor)
        if string == "King"{
            piece.type = .king
        } else if string == "Queen"{
            piece.type = .queen
        } else if string == "Pawn"{
            piece.type = .pawn
        } else if string == "Griffin"{
            piece.type = .griffin
        }
        return piece
    }
    
    func getInfo(piece: ChessPiece) -> String {
        //NSLog("getting info")
        var string = ""
        if piece.type == .king{
            string = "Can move and attack one space in every direction. The game ends when a player runs out of kings. You need to place at least one of them or a superking to begin the game."
        } else if piece.type == .pawn{
            string = "Can move two spaces on its first turn. After that, it can move one space forward. Attacks one space diagonally forward. The basic piece in standard chess. If it reaches the far end of the game board, it can be turned into a more powerful piece"
        } else if piece.type == .queen{
            string = "Can move infinitely vertically, horizontally, and diagonally. The most powerful piece in standard chess."
        } else if piece.type == .griffin{
            string = "Moves one space diagonally, then infinitely vertically and horizontally away from that space. Very powerfuly in the end game with lots of open space."
        }
        return string
    }

}

extension PlacePiecesViewController: BoardCellDelegate {
    
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int) {
        //NSLog("I have been chosen!")
        //print("Selected cell at: \(row), \(col)")
        //chessBoard.board[row][col].showPieceInfo()
        // Check if making a move (if had selected piece before)
        //clear the other highlighted pieces
        highlightedCell.removeHighlighting()
        piecePicture.backgroundColor = cell.backgroundColor //change the square to be the same color as the current space. Small touch
        cell.backgroundColor = cell.hexStringToUIColor(hex:"6DAFFB")
        highlightedCell = cell
        
           
    }

}

