/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SpriteKit

final class OnlineGameScene: SKScene {
    // MARK: - Enums
    
    private enum NodeLayer: CGFloat {
        case background = 100
        case board = 101
        case token = 102
        case ui = 1000
    }
    
    // MARK: - Properties
    
    private var model: GameModel
    
//    private var boardNode: BoardNode!
//    private var messageNode: InformationNode!
//    private var selectedTokenNode: TokenNode?
//
    private var highlightedTokens = [SKNode]()
//    private var removableNodes = [TokenNode]()
    
    private var isSendingTurn = false
    
    private let successGenerator = UINotificationFeedbackGenerator()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: Computed
    
    private var viewWidth: CGFloat {
        return view?.frame.size.width ?? 0
    }
    
    private var viewHeight: CGFloat {
        return view?.frame.size.height ?? 0
    }
    
    // MARK: - Init
    
    init(model: GameModel) {
        self.model = model
        
        super.init(size: .zero)
        
        scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        successGenerator.prepare()
        feedbackGenerator.prepare()
        
        setUpScene(in: view)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        removeAllChildren()
        setUpScene(in: view)
    }
    
    // MARK: - Setup
    
    private func setUpScene(in view: SKView?) {
        guard viewWidth > 0 else {
            return
        }
        
        //backgroundColor = .background
        
        var runningYOffset: CGFloat = 0
        
        let sceneMargin: CGFloat = 40
        let safeAreaTopInset = view?.window?.safeAreaInsets.top ?? 0
        let safeAreaBottomInset = view?.window?.safeAreaInsets.bottom ?? 0
        
        let padding: CGFloat = 24
        let boardSideLength = min(viewWidth, viewHeight) - (padding * 2)
//        boardNode = BoardNode(sideLength: boardSideLength)
//        boardNode.zPosition = NodeLayer.board.rawValue
        runningYOffset += safeAreaBottomInset + sceneMargin + (boardSideLength / 2)
//        boardNode.position = CGPoint(
//            x: viewWidth / 2,
//            y: runningYOffset
//        )
        
//        addChild(boardNode)
//
        let groundNode = SKSpriteNode(imageNamed: "ground")
        let aspectRatio = groundNode.size.width / groundNode.size.height
        let adjustedGroundWidth = view?.bounds.width ?? 0
        groundNode.size = CGSize(
            width: adjustedGroundWidth,
            height: adjustedGroundWidth / aspectRatio
        )
        groundNode.zPosition = NodeLayer.background.rawValue
        runningYOffset += sceneMargin + (boardSideLength / 2) + (groundNode.size.height / 2)
        groundNode.position = CGPoint(
            x: viewWidth / 2,
            y: runningYOffset
        )
        addChild(groundNode)
    }
    
    // MARK: - Helpers
    
    func returnToMenu() {
//        view?.presentScene(MenuScene(), transition: SKTransition.push(with: .down, duration: 0.3))
    }
    
//    private func handlePlacement(at location: CGPoint) {
//        let node = atPoint(location)
//
//        guard node.name == BoardNode.boardPointNodeName else {
//            return
//        }
//
//        guard let coord = boardNode.gridCoordinate(for: node) else {
//            return
//        }
//
//        spawnToken(at: node.position, for: model.currentPlayer)
//        model.placeToken(at: coord)
//
//        processGameUpdate()
//    }
    
//    private func handleMovement(at location: CGPoint) {
//        let node = atPoint(location)
//
//        if let selected = selectedTokenNode {
//            if highlightedTokens.contains(node) {
//                let selectedSceneLocation = convert(selected.position, from: boardNode)
//
//                guard let fromCoord = gridCoordinate(at: selectedSceneLocation), let toCoord = boardNode.gridCoordinate(for: node) else {
//                    return
//                }
//
//                model.move(from: fromCoord, to: toCoord)
//                processGameUpdate()
//
//                selected.run(SKAction.move(to: node.position, duration: 0.175))
//            }
//
//            deselectCurrentToken()
//        } else {
//            guard let token = node as? TokenNode, token.type == model.currentPlayer else {
//                return
//            }
//
//            selectedTokenNode = token
//
//            if model.tokenCount(for: model.currentPlayer) == 3 {
//                highlightTokens(at: model.emptyCoordinates)
//                return
//            }
//
//            guard let coord = gridCoordinate(at: location) else {
//                return
//            }
//
//            highlightTokens(at: model.neighbors(at: coord))
//        }
//    }
    
  

    
//    private func processGameUpdate() {
//        messageNode.text = model.messageToDisplay
//
//        if model.isCapturingPiece {
//            successGenerator.notificationOccurred(.success)
//            successGenerator.prepare()
//
//            let tokens = model.removableTokens(for: model.currentOpponent)
//
//            if tokens.isEmpty {
//                model.advance()
//                processGameUpdate()
//                return
//            }
//
//            let nodes = tokens.compactMap { token in
//                boardNode.node(at: token.coord, named: TokenNode.tokenNodeName) as? TokenNode
//            }
//
//            removableNodes = nodes
//
//            nodes.forEach { node in
//                node.isIndicated = true
//            }
//        } else {
//            feedbackGenerator.impactOccurred()
//            feedbackGenerator.prepare()
//
//            isSendingTurn = true
//
//            if model.winner != nil {
//                GameCenterHelper.helper.win { error in
//                    defer {
//                        self.isSendingTurn = false
//                    }
//
//                    if let e = error {
//                        print("Error winning match: \(e.localizedDescription)")
//                        return
//                    }
//
//                    self.returnToMenu()
//                }
//            } else {
//                GameCenterHelper.helper.endTurn(model) { error in
//                    defer {
//                        self.isSendingTurn = false
//                    }
//
//                    if let e = error {
//                        print("Error ending turn: \(e.localizedDescription)")
//                        return
//                    }
//
//                    self.returnToMenu()
//                }
//            }
//        }
//    }
}
