//
//  PlacePiecesViewController.swift
//  Team Kookaburra Chess
//
//  Created by Meghan Stovall on 3/30/19.
//  Copyright © 2019 Christopher Blake Cassell Erquiaga. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

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
    
    //@IBOutlet SKView: skView;
    
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
    var p2BoardCells = [[BoardCell]]()
    var localMatch = true
    
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
    var pickerString: String = ""
    var chosenPieces = [[ChessPiece]]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setLabels()
        drawBoard()
        addStarterKing()
        piecePicker.delegate = self
        piecePicker.dataSource = self
        pickerData = ["Empty", "King"]
        var ownedPieces: [String]
        ownedPieces = UserDefaults.standard.array(forKey: "ownedPieces") as! [String]
        ownedPieces.sort()
        for piece in ownedPieces{
            pickerData.append(piece)
        }
        piecePicker.selectRow(0, inComponent: 0, animated: true)
        piecePicker.selectRow(0, inComponent: 0, animated: true)
        //get the string from the picker
        pickerString = pickerData[0]
        //compare that string to the piece types
        let piece = getPiece(string: pickerString)
        //assign the .png file to the UIImageview
        piece.setupSymbol()
        piecePicture.image = piece.symbolImage
        //assign info text to the info label
        pieceInfo.text = getInfo(piece: piece)
        pieceInfo.contentMode = .scaleToFill
        pieceInfo.numberOfLines = 0
        //assign cost to the top label
        pieceCost.text = "Cost: \(piece.summonCost) points"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LocalMatchSegue") {
            let vc = segue.destination as! ChessVC
            vc.playerColor = playerColor
            vc.isLocalMatch = true
            if playerColor == .white{
                vc.whiteFormation = boardCells
                vc.blackFormation = p2BoardCells
            } else {//playerColor == .black
                vc.blackFormation = boardCells
                vc.whiteFormation = p2BoardCells
            }
        }
    }
    
    func setLabels(){
        quantLabel.text = "/450"
        pointsRemaining.text = "Points spent: \(playerPoints)"
        if playerColor == .white{
            yourColor.text = "You are white this match"
        } else {
            yourColor.text = "You are black this match"
        }
        tipLabel.text = "Tap a square to select a space and start placing pieces!"
        let piece = getPiece(string: pickerString)
        pieceInfo.text = getInfo(piece: piece)
    }
    
    //players get confused, so we should have a king out there to start. Having it in the regular chess position makes the most sense
    func addStarterKing(){
        var king = ChessPiece(row: 0, column: 0, color: playerColor, type: .king, player: playerColor)
        king.setupSymbol()
        if playerColor == .white{
            king.row = 2
            king.col = 3
            boardCells[2][3].piece = king
            boardCells[2][3].configureCell(forPiece: king)
        } else if playerColor == .black{
            king.row = 2
            king.col = 4
            boardCells[2][4].piece = king
            boardCells[2][4].configureCell(forPiece: king)
        }
        playerPoints = calculateCost()
        pointsRemaining.text = "Points spent: \(playerPoints)"
    }
    
    func drawBoard(){
        let numRows:Int = 8
        let numCols:Int = 8
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
        self.boardCells = Array(repeating: oneRow, count: numRows)
        let cellDimension = (view.frame.size.width - 0) / CGFloat(numCols)
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        let start_row = 0
        let end_row = 2
        for row in start_row...end_row {
            
            yOffset = (CGFloat(row - start_row) * cellDimension) + cellDimension*3//200
            
            for col in 0...7 {
                
                xOffset = (CGFloat(col) * cellDimension) + 0
                
                // create a piece
                var piece = ChessPiece(row: row, column: col, color: .white, type: .dummy, player: .white)
                
                // create a cell at this location with this piece, and set color
                let cell = BoardCell(row: row, column: col, piece: piece, color: .white)
                
                // NSLog("Board cells at row, col: \(boardCells[row][col])")
                
                cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                    cell.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                } else {
                    cell.color = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
                }
                
                cell.removeHighlighting()
                
                // wire up the cell
                cell.delegate = self
                chessBoard.board[row][col] = piece
                self.boardCells[row][col] = cell
                
                
                view.addSubview(cell)
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
        drawBoard()
        playerPoints = calculateCost()
        pointsRemaining.text = "Points spent: \(playerPoints)"
    }
    
    
    @IBAction func placeButtonPressed(_ sender: Any) {
        //check that for chess piece type
        var chosenPiece = getPiece(string: pickerString)
        chosenPiece.setupSymbol()
        //check if the piece is illegally placed
        var cost = chosenPiece.summonCost
        if chosenPiece.type == .king{
            //NSLog("All hail!")
            if numKings(color: playerColor) > 0{
                cost = cost + 20
            }
        }
        if (playerPoints + cost) > 450 {
            //NSLog("Too many points spent")
            tipLabel.text = "Not enough points for that piece"
            let ac = UIAlertController(title: "Points", message: "You don't have enough points for that piece", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
        } else{
            NSLog("check if the piece is illegally placed")
            //check if the piece is illegally placed
            if ((chosenPiece.type == .dragonRider)){

                if  highlightedCell.row != 2{
                        //NSLog("Dragonriders can only be in the back row")
                        tipLabel.text = "Dragonriders can only be in the back row."
                    let ac = UIAlertController(title: "Rule", message: "Dragon Riders can only be placed in the back row", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    ac.addAction(ok)
                    present(ac, animated: true, completion: nil)
                    return
                } //else if highlightedCell.row == 2 && !secondRowFull(){
                            //change the tip label
                            //show a notification, "piece can't be placed because of rule"
                //}
            }
            if highlightedCell.row == 0{
                //print("front row")
                if chosenPiece.type != .dummy{
                    //print("not empty piece")
                    if secondRowFull() == false{
                        tipLabel.text = "Can't place in front row until 2nd row is full."
                        let ac = UIAlertController(title: "Rule", message: "You can't place pieces in the front row until you fill the middle row.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        ac.addAction(ok)
                        present(ac, animated: true, completion: nil)
                        return
                    }
                }
            } else if highlightedCell.row == 1{
                if chosenPiece.type == .dummy{
                    self.clearFrontRow()
                    self.tipLabel.text = "Fill the second row to be able place in the front row"
                }
            }
            chosenPiece.row = highlightedCell.row
            chosenPiece.col = highlightedCell.column
            highlightedCell.configureCell(forPiece: chosenPiece)
            var changedBoardCell = self.boardCells[highlightedCell.row][highlightedCell.column];
            //NSLog("boardcell changed: \(changedBoardCell.piece.type)");
            //add summon points
            //print("points before: \(playerPoints)")
            playerPoints = calculateCost()
            //print("points after: \(playerPoints)")
            pointsRemaining.text = "Points spent: \(playerPoints)"
            //chosenPieces[highlightedCell.row][highlightedCell.column] = chosenPiece
            //NSLog("chosen pieces: \(chosenPieces)")
            //}
            //}
        }
        
    }
    
    //returns if the highlighted cell is in the front row
    func isFrontRow() -> Bool{
        if ((highlightedCell.row == 2) || (highlightedCell.row == 5)){
            return true
        }
        return false
    }
    
    func secondRowFull() -> Bool{
        for col in 0...7 {
            let piece = boardCells[1][col].piece
            if (piece.type == .dummy) {
                return false
            }
        }
        return true
    }
    
    func clearFrontRow(){
        let numRows:Int = 8
        let numCols:Int = 8
        let oneRow = Array(repeating: BoardCell(row: 5, column: 5, piece: ChessPiece(row: 5, column: 5, color: .clear, type: .dummy, player: playerColor), color: .clear), count: 8)
        self.boardCells = Array(repeating: oneRow, count: numRows)
        let cellDimension = (view.frame.size.width - 0) / CGFloat(numCols)
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        let start_row = 0
        let end_row = 0
        for row in start_row...end_row {
            
            yOffset = (CGFloat(row - start_row) * cellDimension) + 200
            
            for col in 0...7 {
                
                xOffset = (CGFloat(col) * cellDimension) + 0
                
                // create a piece
                var piece = ChessPiece(row: row, column: col, color: .white, type: .dummy, player: .white)
                
                // create a cell at this location with this piece, and set color
                let cell = BoardCell(row: row, column: col, piece: piece, color: .white)
                
                // NSLog("Board cells at row, col: \(boardCells[row][col])")
                
                cell.frame = CGRect(x: xOffset, y: yOffset, width: cellDimension, height: cellDimension)
                if (row % 2 == 0 && col % 2 == 0) || (row % 2 != 0 && col % 2 != 0) {
                    cell.color = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                } else {
                    cell.color = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
                }
                
                cell.removeHighlighting()
                
                // wire up the cell
                cell.delegate = self
                chessBoard.board[row][col] = piece
                self.boardCells[row][col] = cell
                
                
                view.addSubview(cell)
            }
        }
    }
    
    func calculateCost() -> Int{
        var cost = 0
        var allPieces = [ChessPiece]()
        var kingCount = 0
        for row in 0...7 {
            for col in 0...7 {
                let piece = boardCells[row][col].piece
                if (piece.type != .dummy) {
                    allPieces.append(piece)
                }
            }
        }
        
        for piece in allPieces {
            if piece.type == .king{
                if kingCount > 0{
                    cost = cost + 60
                } else {
                    cost = cost + 40
                }
                kingCount = kingCount + 1
            } else {
                cost = cost + piece.summonCost
            }
        }
        return cost
    }
    
    
    func numKings(color: UIColor) -> Int {
        var numKings = 0
        //iterate through pieces of each color
        // let allPieces = boardCells.getAllPieces(forPlayer: color)
        // replace by iterating through all self.boardCells, and asking the cell what piece it has
        var allPieces = [ChessPiece]()
        for row in 0...7 {
            for col in 0...7 {
                let piece = boardCells[row][col].piece
                if (piece.type != .dummy) {
                    allPieces.append(piece)
                }
            }
        }
        
        for piece in allPieces {
            if piece.type == .king{
                numKings = numKings + 1
            } else if piece.type == .superKing{
                numKings = numKings + 1
            }
        }
        return numKings
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
        if numKings(color: playerColor) > 0{
        if localMatch == true{
            if playerColor == .white{ //
                p2BoardCells = boardCells
                playerColor = .black
                clearPieces()
                setLabels()
                piecePictureSetup()
                addStarterKing()
            } else {
                localMatchReady()
            }
        } else {
            //do multiplayer stuff
        }
        } else {
            tipLabel.text = "Place a king, then you can play!"
            let ac = UIAlertController(title: "Rule", message: "You need to place at least one king before you can play", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
        }
    }
    
    func onlineMatchReady(){
        if playerPoints < 440{
            //if not, ask them if they're sure they want to ready up
            let ac = UIAlertController(title: "Points remaining", message: "You still have points to spend, ready anyway?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Ready!", style: .default, handler: { action in
                self.performSegue(withIdentifier: "OnlineMatchSegue", sender: self)
            })
            let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            ac.addAction(yes)
            ac.addAction(no)
            present(ac, animated: true, completion: nil)
            return
        }
    }
    
    func localMatchReady(){
            //check if the player has used up enough points (at least 440)
            if playerPoints < 440{
                //if not, ask them if they're sure they want to ready up
                let ac = UIAlertController(title: "Points remaining", message: "You still have points to spend, ready anyway?", preferredStyle: .alert)
                let yes = UIAlertAction(title: "Ready!", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "LocalMatchSegue", sender: self)
                })
                let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                ac.addAction(yes)
                ac.addAction(no)
                present(ac, animated: true, completion: nil)
                return
            }
            self.performSegue(withIdentifier: "LocalMatchSegue", sender: self)//start the game with the current piece placement
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
        pieceInfo.contentMode = .scaleToFill
        pieceInfo.numberOfLines = 0
        //assign cost to the top label
        pieceCost.text = "Cost: \(piece.summonCost) points"
        if piece.type == .king{
            pieceCost.text = "Cost: 40 for the 1st, 60 after"
        }
    }
    
    //quickly resets the selected piece picture. Mostly useful for local matches when
    //the players switch colors
    func piecePictureSetup(){
        pickerString = pickerData[pickerData.firstIndex(of: pickerString)!]
        let piece = getPiece(string: pickerString)
        piece.setupSymbol()
    }
    
    func getPiece(string: String) -> ChessPiece {
        NSLog("getting piece")
        var piece = ChessPiece(row: -1, column: -1, color: playerColor, type: .dummy, player: playerColor)
        switch string{
        case "Empty":
            piece.type = .dummy
        case "King":
            piece.type = .king
        case "Archer":
            piece.type = .archer
        case "Ballista":
            piece.type = .ballista
        case "Basilisk":
            piece.type = .basilisk
        case "Battering Ram":
            piece.type = .batteringRam
        case "Bishop":
            piece.type = .bishop
        case "Bombard":
            piece.type = .bombard
        case "Camel":
            piece.type = .camel
        case "Centaur":
            piece.type = .centaur
        case "Demon":
            piece.type = .demon
        case "Dragon Rider":
            piece.type = .dragonRider
        case "Dwarf":
            piece.type = .dwarf
        case "Elephant":
            piece.type = .elephant
        case "Fire Dragon":
            piece.type = .fireDragon
        case "Footsoldier":
            piece.type = .footSoldier
        case "Gargoyle":
            piece.type = .gargoyle
        case "Ghost Queen":
            piece.type = .ghostQueen
        case "Goblin":
            piece.type = .goblin
        case "Griffin":
            piece.type = .griffin
        case "Ice Dragon":
            piece.type = .iceDragon
        case "Knight":
            piece.type = .knight
        case "Left Handed Elf Warrior":
            piece.type = .leftElf
        case "Mage":
            piece.type = .mage
        case "Man at Arms":
            piece.type = .manAtArms
        case "Manticore":
            piece.type = .manticore
        case "Minotaur":
            piece.type = .minotaur
        case "Monk":
            piece.type = .monk
        case "Monopod":
            piece.type = .monopod
        case "Ogre":
            piece.type = .ogre
        case "Orc Warrior":
            piece.type = .orcWarrior
        case "Pawn":
            piece.type = .pawn
        case "Pikeman":
            piece.type = .pikeman
        case "Queen":
            piece.type = .queen
        case "Right Handed Elf Warrior":
            piece.type = .rightElf
        case "Rook":
            piece.type = .rook
        case "Royal Guard":
            piece.type = .royalGuard
        case "Scout":
            piece.type = .scout
        case "Ship":
            piece.type = .ship
        case "Superking":
            piece.type = .superKing
        case "Swordsman":
            piece.type = .swordsman
        case "Trebuchet":
            piece.type = .trebuchet
        case "Unicorn":
            piece.type = .unicorn
        default:
            piece.type = .dummy
        }
        return piece
    }
    
    func getInfo(piece: ChessPiece) -> String {
        NSLog("getting info")
        var string = ""
        
        switch piece.type{
        case .king:
            string = "Can move and attack one space in every direction. The game ends when a player runs out of kings. You need to place at least one of them or a superking to begin the game."
        case .dummy:
            string = ""
        case .unicorn:
            string = "Can move as both a queen and a knight, making it very difficult for opponents to capture."
        case .superKing:
            string = "Counts as a king, but can move like a queen. You need to place at least one of them or a king to begin the game."
        case .griffin:
            string = "Moves one space diagonally, then infinitely vertically and horizontally away from that space. Very powerfuly in the end game with lots of open space."
        case .queen:
            string = "Can move infinitely vertically, horizontally, and diagonally. The most powerful piece in standard chess."
        case .mage:
            string = "Can move like both a bishop and a knight."
        case .centaur:
            string = "Can move like both a rook and a knight."
        case .dragonRider:
            string = "Moves like a knight, but can continue in that direction infinitely. This piece is so powerful that it can only be placed in the back row."
        case .bombard:
            string = "Can move to any space one or two spaces away, but can only attack two spaces away."
        case .manticore:
            string = "Can move one or two spaces in any direction, but can only attack one space away, like a king."
        case .ghostQueen:
            string = "Moves like a queen, but can't attack enemy pieces. Useful for protecting more valuable pieces."
        case .rook:
            string = "Can move infinitely in horizontal and vertical lines. Placed in the corners in regular chess."
        case .knight:
            string = "Jumps to spaces that are two spaces up and one space over, or two spaces over and one space up. Placed next to the corners in regular chess."
        case .bishop:
            string = "Can move infinitely in diagonal lines. Placed next to the king and queen in regular chess."
        case .basilisk:
            string = "Can move and attack one space away like a king, and can also move infinitely in a horizontal line."
        case .fireDragon:
            string = "Moves like a bishop, but attacks like a rook."
        case .iceDragon:
            string = "Moves like a rook, but attacks like a bishop."
        case .minotaur:
            string = "Jumps two or three spaces away vertically or diagonally."
        case .monopod:
            string = "Jumps to any space two spaces away."
        case .ship:
            string = "Can move one space diagonally, then infinitely vertically from that space."
        case .ballista:
            string = "Moves vertically towards the opposing side but diagonally towards yours."
        case .batteringRam:
            string = "Moves vertically and diagonally, but only towards the opposing side. Good at taking out high-value opposing pieces early in the game."
        case .trebuchet:
            string = "Moves diagonally towards the opposing side and vertically towards yours."
        case .leftElf:
            string = "Going left, it moves like a bishop. Going right, it moves like a knight."
        case .rightElf:
            string = "Going right, it moves like a bishop. Going left, it moves like a knight."
        case .camel:
            string = "Moves like a knight, but jumping 3 spaces and over at a time instead of 2."
        case .scout:
            string = "Jumps like a knight towards the opposing side and can move one space backwards. Can't jump backwards or laterally."
        case .ogre:
            string = "Moves one space diagonally."
        case .orcWarrior:
            string = "Moves one space vertically or horizontally."
        case .elephant:
            string = "Moves one space vertically or horizontally, but attacks one space diagonally."
        case .manAtArms:
            string = "Moves one space diagonally, but attacks one space vertically or horizontally."
        case .swordsman:
            string = "Can move one space directly forward or diagonally towads the opposing side."
        case .pikeman:
            string = "Jumps two spaces horizontally or vertically."
        case .archer:
            string = "Jumps two spaces diagonally."
        case .royalGuard:
            string = "Moves just like a king, but doesn't count as a king."
        case .demon:
            string = "Can move one space horizontally, but attacks diagonally and verticlly one space."
        case .pawn:
            string = "Can move two spaces on its first turn. After that, it can move one space forward. Attacks one space diagonally forward. The basic piece in standard chess. If it reaches the far end of the game board, it can be turned into a more powerful piece"
        case .monk:
            string = "Like a pawn, but both moves and attacks diagonally."
        case .dwarf:
            string = "Like a pawn, but moves diagonally and attacks forward."
        case .gargoyle:
            string = "Can't move unless attacking, but can attack any adjacent space."
        case .goblin:
            string = "Like a pawn, but moves and attacks forwards."
        case .footSoldier:
            string = "Like a pawn, but moves two spaces at a time and attacks horizontally instead of diagonally."
        default:
            string = ""
    }
    return string
}
}

extension PlacePiecesViewController: BoardCellDelegate {
    
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int) {
        //NSLog("I have been chosen! \(row), \(col)")
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
