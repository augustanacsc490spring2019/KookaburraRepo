//
//  Originally created by Mikael Mukhsikaroyan on 11/1/16.
//  Used and modified under MIT License
//

import UIKit

protocol BoardCellDelegate {
    func didSelect(cell: BoardCell, atRow row: Int, andColumn col: Int)
}

class BoardCell: UIView {
    
    var row: Int
    var column: Int
    var piece: ChessPiece
    var color: UIColor
    var delegate: BoardCellDelegate?
    
    lazy var invisibleButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(selectedCell(sender:)), for: .touchUpInside)
        return b
    }()
    
    let pieceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 40)
        l.minimumScaleFactor = 0.5
        return l
    }()
    
    init(row: Int, column: Int, piece: ChessPiece, color: UIColor) {
        self.row = row
        self.column = column
        self.piece = piece
        self.color = color
        super.init(frame: .zero)
        self.backgroundColor = color
        setupViews()
        
        pieceLabel.text = piece.symbol
        pieceLabel.textColor = piece.color
    }
    
    func setupViews() {
        addSubview(invisibleButton)
        invisibleButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        invisibleButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        invisibleButton.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        invisibleButton.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
        
        addSubview(pieceLabel)
        pieceLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        pieceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        pieceLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        pieceLabel.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
    }
    
    func configureCell(forPiece piece: ChessPiece) {
        row = piece.row
        column = piece.col
        self.piece = piece
        
        pieceLabel.text = piece.symbol
        pieceLabel.textColor = piece.color
        backgroundColor = color
    }
    
    func setAsPossibleLocation() {
        backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
    
    func removeHighlighting() {
        backgroundColor = color
    }
    
    @objc func selectedCell(sender: UIButton) {
        //print("Selected cell at: \(row), \(column)")
        delegate?.didSelect(cell: self, atRow: row, andColumn: column)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
