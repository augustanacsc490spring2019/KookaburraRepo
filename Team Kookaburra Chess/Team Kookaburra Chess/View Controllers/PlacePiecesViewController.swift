//
//  PlacePiecesViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit

class PlacePiecesViewController: UIViewController {
    var playerColor: UIColor = .white
    var playerPoints: Int = 0
    var chessBoard = ChessBoard(playerColor: .white)
    var boardCells = [[BoardCell]]()
    var pieceBeingMoved: ChessPiece? = nil
    var possibleMoves = [BoardIndex]()
    var playerTurn = UIColor.white
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var quantLabel: UILabel!
    @IBOutlet weak var pointsRemaining: UILabel!
    @IBOutlet weak var yourColor: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var pieceName: UILabel!
    @IBOutlet weak var piecePicture: UIImageView!
    @IBOutlet weak var piceInfo: UILabel!
    @IBOutlet weak var piecePicker: UIPickerView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setLabels()
        drawBoard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLabels(){
        quantLabel.text = "450"
        pointsRemaining.text = "\(playerPoints)"
        
    }
    
    func drawBoard(){
            let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
            var boardCells = Array(repeating: oneRow, count: 8)
            let cellDimension = (view.frame.size.width - 0) / 8
            var xOffset: CGFloat = 0
            var yOffset: CGFloat = 100
            for row in 0...3 {
                yOffset = (CGFloat(row) * cellDimension) + 80
                xOffset = 50
                for col in 0...7 {
                    xOffset = (CGFloat(col) * cellDimension) + 0
                    
                    let piece = chessBoard.board[row][col]
                    let cell = BoardCell(row: row, column: col, piece: piece, color: .white)
                    //cell.delegate = self
                    boardCells[row][col] = cell
                    
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
        }
    
}
