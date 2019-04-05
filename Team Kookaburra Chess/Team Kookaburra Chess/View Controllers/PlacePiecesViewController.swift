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
    var pickerData: [String] = [String]()
    
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
//        self.piecePicker.delegate = self as UIPickerViewDelegate
//        self.piecePicker.dataSource = self as! UIPickerViewDataSource
        pickerData = ["Empty (0)", "King (40)", "Pawn (10)", "Griffin (130)"]
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
        
    }
    
    func drawBoard(){
            let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
            var boardCells = Array(repeating: oneRow, count: 8)
            let cellDimension = (view.frame.size.width - 0) / 8
            var xOffset: CGFloat = 0
            var yOffset: CGFloat = 300
            for row in 0...2 {
                yOffset = (CGFloat(row) * cellDimension) + 200
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
                    //empty the cell
                    cell.piece.type = .dummy
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
    
}
