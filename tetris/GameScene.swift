//
//  GameScene.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import SpriteKit
import GameKit
import GameplayKit

struct Piece {
    var array: Array2D
    var number: Int
    
    subscript(column: Int, row: Int) -> Int {
        
        get {
            return array[column, row]
        }
        set {
            array[column, row] = newValue
        }
    }

    mutating func rotate(direction: Direction) {
        var newArray = Array2D(columns: array.columns, rows: array.rows)
        let length = array.columns

        switch direction {
        case .left:
            for col in 0..<array.columns {
                for row in 0..<array.rows {
                    newArray[row, col] = array[col, length - 1 - row];
                }
            }
            array = newArray
        case .right:
            for col in 0..<array.columns {
                for row in 0..<array.rows {
                    newArray[row, col] = array[length - 1 - col, row];
                }
            }
            array = newArray
        default:
            return
        }
    }
}

enum Direction {
    case left, down, right
}

enum MoveResult {
    case moved, blocked
}

class GameScene: SKScene {

    var score = 0
    var lines = 0
    var scoreLabel: SKLabelNode!
    var linesLabel: SKLabelNode!
    var nextPieceTileMap: SKTileMapNode!
    
    var gameField: SKTileMapNode!
    let columns = 12
    let rows = 22
    let width = 32
    let height = 32
    let scaleX = 1.754
    let scaleY = 1.524

    var solidPieceLayer: Array2D!
    var pieces = [Piece]()

    var fallingPieceLayer: Array2D!
    var fallingPiece: Piece!
    var nextFallingPiece: Piece!

    var tileSet: SKTileSet!
    var blueBrick: SKTileGroup!
    var cyanBrick: SKTileGroup!
    var greenBrick: SKTileGroup!
    var orangeBrick: SKTileGroup!
    var purpleBrick: SKTileGroup!
    var redBrick: SKTileGroup!
    var yellowBrick: SKTileGroup!
    var field: SKTileGroup!

    var direction: Direction = .down
    var previousDirection: Direction = .down

    let fallingLayerInitialNumber = 99
    let biggestPieceLength = 3

    var gameOver = false

    override func didMove(to view: SKView) {
        self.view?.preferredFramesPerSecond = 1

        solidPieceLayer = Array2D(columns: columns, rows: rows)
        fallingPieceLayer = Array2D(columns: columns + biggestPieceLength * 2, rows: rows + biggestPieceLength, initialNumber: fallingLayerInitialNumber)
        setupPices()
        setupTiles()

        gameField = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: CGSize(width: width, height: height))
        gameField.xScale = CGFloat(scaleX)
        gameField.yScale = CGFloat(scaleY)
        addChild(gameField)

        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel.text = String(score)
        linesLabel = childNode(withName: "linesLabel") as? SKLabelNode
        linesLabel.text = String(lines)

        nextPieceTileMap = childNode(withName: "nextPieceTileMap") as? SKTileMapNode
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeftGestureRecognizer.direction = .left
        view.addGestureRecognizer(swipeLeftGestureRecognizer)

        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRightGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeRightGestureRecognizer)

        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeUpGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeUpGestureRecognizer)

        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeDownGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownGestureRecognizer)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressGestureRecognizer.minimumPressDuration = TimeInterval(0.3)
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc func swiped(gesture : UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            direction = .left
        case UISwipeGestureRecognizer.Direction.right:
            direction = .right
        case UISwipeGestureRecognizer.Direction.up:
            if canRotate(direction: .left) {
                fallingPiece.rotate(direction: .left)
                updateFallingLayer()
            }
        case UISwipeGestureRecognizer.Direction.down:
            if canRotate(direction: .right) {
                fallingPiece.rotate(direction: .right)
                updateFallingLayer()
            }
                
        default:
            return
        }
    }

    @objc func longPress(gesture : UILongPressGestureRecognizer) {
        if gesture.state == .began {
            view?.preferredFramesPerSecond = 3
        } else if gesture.state == .ended {
            view?.preferredFramesPerSecond = 1
        }
        
    }

    override func update(_ currentTime: TimeInterval) {

        if !gameOver {
            if previousDirection == direction && direction != .down {
                direction = .down
            }
            
            if nextFallingPiece == nil {
                if fallingPiece == nil {
                    fallingPiece = generateNewPiece()
                    initialPosition()
                }
                
                nextFallingPiece = generateNewPiece()
                updateNextPieceTileMap()
            }
            
            if move(piece: fallingPiece, direction: direction) == .blocked{
                fallingPiece = nextFallingPiece
                initialPosition()
                nextFallingPiece = nil
            }
            updateGameField()
            
            previousDirection = direction
            direction = .down
        }
    }

    func updateNextPieceTileMap() {
        for col in 0..<4 {
            for row in 0..<4 {
                nextPieceTileMap.setTileGroup(nil, forColumn: col, row: row)
            }
        }

        for col in 0..<nextFallingPiece.array.columns {
            for row in 0..<nextFallingPiece.array.rows {
                nextPieceTileMap.setTileGroup(getTileForNumber(number: nextFallingPiece[col, row]), forColumn: col, row: row)
            }
        }
    }

    func setupTiles() {
        guard let tileSet = SKTileSet(named: "Tile Sets") else {
            fatalError("Tile Sets not found")
        }

        self.tileSet = tileSet
        let tileGroups = tileSet.tileGroups

        guard let blueBrick = tileGroups.first(where: {$0.name == "blue"}) else {
            fatalError("No blueBrick tile definition found")
        }
        self.blueBrick = blueBrick

        guard let cyanBrick = tileGroups.first(where: {$0.name == "cyan"}) else {
            fatalError("No cyanBrick tile definition found")
        }
        self.cyanBrick = cyanBrick

        guard let greenBrick = tileGroups.first(where: {$0.name == "green"}) else {
            fatalError("No greenBrick tile definition found")
        }
        self.greenBrick = greenBrick

        guard let orangeBrick = tileGroups.first(where: {$0.name == "orange"}) else {
            fatalError("No orangeBrick tile definition found")
        }
        self.orangeBrick = orangeBrick

        guard let purpleBrick = tileGroups.first(where: {$0.name == "purple"}) else {
            fatalError("No purpleBrick tile definition found")
        }
        self.purpleBrick = purpleBrick

        guard let redBrick = tileGroups.first(where: {$0.name == "red"}) else {
            fatalError("No redBrick tile definition found")
        }
        self.redBrick = redBrick

        guard let yellowBrick = tileGroups.first(where: {$0.name == "yellow"}) else {
            fatalError("No yellowBrick tile definition found")
        }
        self.yellowBrick = yellowBrick
        
        guard let field = tileGroups.first(where: {$0.name == "field"}) else {
            fatalError("No field tile definition found")
        }
        self.field = field
    }

    func setupPices() {
        var iPiece = Piece(array: Array2D(columns: 4, rows: 4), number: 1)
        iPiece[1,0] = 1
        iPiece[1,1] = 1
        iPiece[1,2] = 1
        iPiece[1,3] = 1
        
        var jPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 2)
        jPiece[0,2] = 2
        jPiece[1,2] = 2
        jPiece[2,2] = 2
        jPiece[2,1] = 2
        
        var lPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 3)
        lPiece[0,1] = 3
        lPiece[0,2] = 3
        lPiece[1,2] = 3
        lPiece[2,2] = 3
        
        var oPiece = Piece(array: Array2D(columns: 2, rows: 2), number: 4)
        oPiece[0,0] = 4
        oPiece[0,1] = 4
        oPiece[1,0] = 4
        oPiece[1,1] = 4

        var sPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 5)
        sPiece[0,1] = 5
        sPiece[1,1] = 5
        sPiece[1,2] = 5
        sPiece[2,2] = 5
        
        var tPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 6)
        tPiece[0,2] = 6
        tPiece[1,1] = 6
        tPiece[1,2] = 6
        tPiece[2,2] = 6

        var zPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 7)
        zPiece[0,2] = 7
        zPiece[1,2] = 7
        zPiece[1,1] = 7
        zPiece[2,1] = 7

        pieces.append(iPiece)
        pieces.append(jPiece)
        pieces.append(lPiece)
        pieces.append(oPiece)
        pieces.append(sPiece)
        pieces.append(tPiece)
        pieces.append(zPiece)
    }

    func generateNewPiece() -> Piece {
        return pieces.randomElement()!
    }
    
    func move(piece: Piece, direction: Direction) -> MoveResult {

        var newPositions = [(col: Int,row: Int)]()
        var positionInPiece = [(col: Int,row: Int)]()
        var firstCoordinate: (col: Int, row: Int)?

        for col in 0..<fallingPieceLayer.columns {
            for row in 0..<fallingPieceLayer.rows {
                if fallingPieceLayer?[col, row] != fallingLayerInitialNumber {

                    let coordinate = (col: col,row: row)
                    var newCoordinate: (col: Int, row: Int)
                    switch direction {
                    case .left:
                        newCoordinate = (coordinate.col - 1, coordinate.row)
                    case .right:
                        newCoordinate = (coordinate.col + 1, coordinate.row)
                    default:
                        newCoordinate = (coordinate.col , coordinate.row - 1)
                    }

                    if (newCoordinate.row < biggestPieceLength &&
                        fallingPieceLayer[coordinate.col, coordinate.row] != 0) ||
                        (newCoordinate.col < biggestPieceLength && fallingPieceLayer[coordinate.col, coordinate.row] != 0 ||
                        newCoordinate.col >= fallingPieceLayer.columns - biggestPieceLength && fallingPieceLayer[coordinate.col, coordinate.row] != 0) ||
                        newCoordinate.col - biggestPieceLength >= 0 &&
                        newCoordinate.row - biggestPieceLength >= 0 &&
                        solidPieceLayer[newCoordinate.col - biggestPieceLength, newCoordinate.row - biggestPieceLength] != 0 &&
                        fallingPieceLayer[coordinate.col, coordinate.row] != 0 {

                        if direction == .down {
                            moveToSolid(piece: piece)
                            fallingPieceLayer.clear(with: fallingLayerInitialNumber)
                            return MoveResult.blocked
                        } else {
                            return move(piece: piece,direction: .down)
                        }

                    } else {
                        
                        if firstCoordinate == nil {
                            firstCoordinate = (col: newCoordinate.col, row: newCoordinate.row)
                        }

                        newPositions.append((newCoordinate.col, newCoordinate.row))
                        positionInPiece.append((newCoordinate.col - firstCoordinate!.col, newCoordinate.row - firstCoordinate!.row))
                    }
                    
                }
            }
        }

        fallingPieceLayer.clear(with: fallingLayerInitialNumber)

        var index = 0
        for col in 0..<piece.array.columns {
            for row in 0..<piece.array.rows {
                if index < newPositions.count {
                    fallingPieceLayer[newPositions[index].col, newPositions[index].row] = piece[col, row]
                }
                index += 1
            }
        }

        return MoveResult.moved
    }

    func canRotate(direction: Direction) -> Bool{
        for col in 0..<fallingPieceLayer.columns {
            for row in 0..<fallingPieceLayer.rows {
                if fallingPieceLayer[col, row] != fallingLayerInitialNumber {
                    if row - biggestPieceLength >= 0 &&
                        col - biggestPieceLength >= 0 &&
                        col - biggestPieceLength + fallingPiece!.array.columns - 1 < columns {
                        return true
                    }

                    return false
                }
            }
        }
        return false
    }

    func moveToSolid(piece: Piece) {
        for col in 0..<columns {
            for row in 0..<rows {
                if fallingPieceLayer?[col + biggestPieceLength, row + biggestPieceLength] != fallingLayerInitialNumber && fallingPieceLayer?[col + biggestPieceLength, row + biggestPieceLength] != 0{
                    solidPieceLayer[col, row] = piece.number
                }
            }
        }
        checkFullLines()
    }

    func updateFallingLayer() {
        var firstCoordinate: (col: Int, row: Int)?
        for col in 0..<fallingPieceLayer.columns {
            for row in 0..<fallingPieceLayer.rows {
                if fallingPieceLayer?[col, row] != fallingLayerInitialNumber {
                    if firstCoordinate == nil {
                        firstCoordinate = (col: col, row: row)
                    }

                    fallingPieceLayer[col, row] = fallingPiece[col - firstCoordinate!.col, row - firstCoordinate!.row]
                }
            }
        }
        
    }

    private func checkFullLines() {

        var clearedRows = 0
        for row in stride(from: solidPieceLayer.rows - 2, through: 0, by: -1) {

            var fullLine = true
            for col in 0..<solidPieceLayer.columns {
                if solidPieceLayer[col, row] == 0 {
                    fullLine = false
                }
            }

            if fullLine {
                for row in row..<(solidPieceLayer.rows - 1) {
                    for col in 0..<solidPieceLayer.columns {
                        solidPieceLayer[col, row] = solidPieceLayer[col, row + 1]
                    }
                }
                clearedRows += 1
            }
        }

        score += clearedRows / 4 * 800
        switch clearedRows % 4 {
        case 1:
            score += 100
        case 2:
            score += 300
        case 3:
            score += 500
        default:
            score += 0
        }

        lines += clearedRows
        scoreLabel.text = String(score)
        linesLabel.text = String(lines)
    }

    func initialPosition() {
        guard let piece = fallingPiece else { return }
        var to = (col: 0, row: 0)

        switch piece.array.columns {
        case 2:
            to = (col: fallingPieceLayer.columns / 2, row: fallingPieceLayer.rows - 2)
        case 3:
            to = (col: fallingPieceLayer.columns / 2 - 2, row: fallingPieceLayer.rows - 3)
        case 4:
            to = (col: fallingPieceLayer.columns / 2 - 2, row: fallingPieceLayer.rows - 4)
        default:
            return
        }

        let toLastCol = to.col + piece.array.columns
        let toLastRow = to.row + piece.array.rows
        for col in to.col..<toLastCol {
            for row in to.row..<toLastRow {
                if solidPieceLayer[col - biggestPieceLength, row - biggestPieceLength] == 0 {
                    fallingPieceLayer[col, row] = fallingPiece[col - to.col, row - to.row]
                } else {
                    gameOver = true
                    NotificationCenter.default.post(name: .presentGameOverViewController, object: nil)
                }
            }
        }
    }

    func updateGameField() {
        for col in 0..<columns {
            for row in 0..<rows {
                gameField.setTileGroup(getTileForNumber(number: solidPieceLayer[col, row]), forColumn: col, row: row)
                if fallingPieceLayer[col + biggestPieceLength, row + biggestPieceLength] != fallingLayerInitialNumber && fallingPieceLayer[col + biggestPieceLength, row + biggestPieceLength] != 0 {
                    gameField.setTileGroup(getTileForNumber(number: fallingPieceLayer[col + biggestPieceLength, row + biggestPieceLength]), forColumn: col, row: row)
                }
            }
        }
    }
    
    func getTileForNumber(number: Int) -> SKTileGroup {
        switch number {
        case 1:
            return cyanBrick
        case 2:
            return blueBrick
        case 3:
            return orangeBrick
        case 4:
            return yellowBrick
        case 5:
            return greenBrick
        case 6:
            return purpleBrick
        case 7:
            return redBrick
        default:
            return field
        }
    }
}
