//
//  piecePickerView.swift
//  Team Kookaburra Chess
//
//  Created by Christopher Blake Cassell Erquiaga on 4/2/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation
import UIKit

class PiecePickerView: UIViewController {
    
    var playerColor: UIColor = .white
    var chessBoard = ChessBoard(playerColor: .white)
    var boardCells = [[BoardCell]]()
    var pieceBeingMoved: ChessPiece? = nil
    var possibleMoves = [BoardIndex]()
    var playerTurn = UIColor.black
    var pointsRemaining: Int = 450
    
    let pieceInfoLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        return l
    }()
    
    let pieceNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        return l
    }()
    
    let yourColorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        return l
    }()
    
    let pointsRemainingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        return l
    }()
    
    let quantLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        return l
    }()
    
    let tipLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        return l
    }()
    
    lazy var resetButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Restart Game", for: [])
        b.setTitleColor(.white, for: [])
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.addTarget(self, action: #selector(resetPressed(sender:)), for: .touchUpInside)
        return b
    }()
    
    lazy var placeButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Restart Game", for: [])
        b.setTitleColor(.white, for: [])
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.addTarget(self, action: #selector(placePressed(sender:)), for: .touchUpInside)
        return b
    }()
    
    //draw a 3x8 boards showing available spaces
    func drawBoard() {
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
        boardCells = Array(repeating: oneRow, count: 8)
        let cellDimension = (view.frame.size.width - 0) / 8
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 100
        for row in 0...2 {
            yOffset = (CGFloat(row) * cellDimension) + 80
            xOffset = 50
            for col in 0...7 {
                xOffset = (CGFloat(col) * cellDimension) + 0
                
                let piece = chessBoard.board[row][col]
                let cell = BoardCell(row: row, column: col, piece: piece, color: .white)
                cell.delegate = self as! BoardCellDelegate
                boardCells[row][col] = cell
                
                view.addSubview(cell)
                cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                //TODO: change depending on player color
                if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                    cell.color = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
                } else {
                    cell.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                }
                // set the color
                cell.removeHighlighting()
            }
        }
        updateLabels()
    }

    func updateLabels() {
        let color = playerTurn == .white ? "White" : "Black"
        yourColorLabel.text = "This match, your color is \(color)"
        pointsRemainingLabel.text = "Summoning Points Remaining: "
        quantLabel.text = "\(pointsRemaining)"
    }
    
    @objc func resetPressed(sender: UIButton) {
        let ac = UIAlertController(title: "Reset", message: "Are you sure you want to remove every piece?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.chessBoard.startNewGame()
        })
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func placePressed(sender: UIButton) {
        //TODO: get the current piece type
        //TODO: check if the piece is allowed to be placed there
        //TODO: get the piece image and the summon cost
        //TODO: check if the player has enough points remaining to place the piece
        //TODO: replace what's at the selected coordinates with the selected piece
        //TODO: recalculate the points remaining and update the label accordingly
        //TODO: if they can't place the piece there, update the tip label
    }
    
    @objc func readyPressed(sender: UIButton) {
        //TODO: check if the player has a king on the board
        //TODO: if not, don't let them ready and change the tip label
        //check if the player has used enough points
        if pointsRemaining > 10{
            let ac = UIAlertController(title: "Poitns remaining", message: "You still have points to spend, ready anyway?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.chessBoard.startNewGame()
            })
            let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac.addAction(yes)
            ac.addAction(no)
            present(ac, animated: true, completion: nil)
        }
        //startGame()
    }
    
    func startGame(){
        //go to the chessView and pass in the piece positions
    }
    
    
}
