//
//  GameScene.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import SpriteKit
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
}

enum Direction {
    case left, down, right
}

enum MoveResult {
    case moved, blocked
}

class GameScene: SKScene {

    var gameField: SKTileMapNode!
    let columns = 24
    let rows = 27
    let width = 40
    let height = 40

    var solidPieceLayer: Array2D!
    var pieces = [Piece]()

    var fallingPieceLayer: Array2D!
    var fallingPiece: Piece!

    var tileSet: SKTileSet!
    var yellowBrick: SKTileGroup!
    var field: SKTileGroup!

    var direction: Direction = .down
    var previousDirection: Direction = .down

    override func didMove(to view: SKView) {
        self.view?.preferredFramesPerSecond = 1

        solidPieceLayer = Array2D(columns: columns, rows: rows)
        fallingPieceLayer = Array2D(columns: columns, rows: rows)
        setupPices()
        setupTiles()

        gameField = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: CGSize(width: width, height: height))
        addChild(gameField)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeftGestureRecognizer.direction = .left
        view.addGestureRecognizer(swipeLeftGestureRecognizer)

        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRightGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeRightGestureRecognizer)
    }

    @objc func swiped(gesture : UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            direction = .left
        case UISwipeGestureRecognizerDirection.right:
            direction = .right
        default:
            return
        }
    }

    override func update(_ currentTime: TimeInterval) {

        if previousDirection == direction && direction != .down {
            direction = .down
        }

        if fallingPiece == nil {
            fallingPiece = generateNewPiece()
            initiatePosition()
        }

        if move(piece: fallingPiece, direction: direction) == .blocked{
            fallingPiece = nil
        }
        updateGameField()

        previousDirection = direction
        direction = .down
    }

    func setupTiles() {
        guard let tileSet = SKTileSet(named: "Tile Sets") else {
            fatalError("Tile Sets not found")
        }

        self.tileSet = tileSet
        let tileGroups = tileSet.tileGroups
        
        guard let yellowBrick = tileGroups.first(where: {$0.name == "YellowBrick"}) else {
            fatalError("No YellowBrick tile definition found")
        }
        self.yellowBrick = yellowBrick
        
        guard let field = tileGroups.first(where: {$0.name == "Field"}) else {
            fatalError("No Field tile definition found")
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

        // Go through the fallingPieceLayer
        for col in 0..<columns {
            for row in 0..<rows {
                if fallingPieceLayer?[col, row] != 0 {

                    // Calculate the new position
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

                    // Good if the new posiotion is in the game field and there is no other objects
                    if newCoordinate.row < 0 ||
                        (newCoordinate.col < 0 || newCoordinate.col >= columns) ||
                        solidPieceLayer[newCoordinate.col, newCoordinate.row] != 0 {
                        
                        if direction == .down {
                            moveToSolid(piece: piece)
                            fallingPieceLayer.clear()
                            return MoveResult.blocked
                        } else {
                            return move(piece: piece,direction: .down)
                        }

                    } else {
                        newPositions.append((newCoordinate.col, newCoordinate.row))
                    }
                    
                }
            }
        }

        fallingPieceLayer.clear()
        for position in newPositions {
            fallingPieceLayer[position.col, position.row] = piece.number
        }

        return MoveResult.moved
    }

    func moveToSolid(piece: Piece) {
//        guard let firstIndex = fallingPieceLayer.array.firstIndex(of: fallingPiece.number) else { return }
//        solidPieceLayer.array.insert(contentsOf: fallingPiece.array.array, at: firstIndex)
        for col in 0..<columns {
            for row in 0..<rows {
                if fallingPieceLayer?[col, row] != 0 {
                    solidPieceLayer[col, row] = piece.number
                }
            }
        }
    }

    func initiatePosition() {
        guard let piece = fallingPiece else { return }
        var to = (col: 0, row: 0)

        switch piece.array.columns {
        case 2:
            to = (col: columns / 2, row: rows - 2)
        case 3:
            to = (col: columns / 2 - 2, row: rows - 3)
        case 4:
            to = (col: columns / 2 - 2, row: rows - 4)
        default:
            return
        }

        let toLastCol = to.col + piece.array.columns
        let toLastRow = to.row + piece.array.rows
        for col in to.col..<toLastCol {
            for row in to.row..<toLastRow {
                if piece[col - to.col, row - to.row] == piece.number {
                    fallingPieceLayer[col, row] = piece.number
                }
            }
        }
    }

    func updateGameField() {
        for col in 0..<columns {
            for row in 0..<rows {
                gameField.setTileGroup(getTileForNumber(number: solidPieceLayer[col, row]), forColumn: col, row: row)
                if fallingPieceLayer[col, row] != 0 {
                    gameField.setTileGroup(getTileForNumber(number: fallingPieceLayer[col, row]), forColumn: col, row: row)
                }
            }
        }
    }
    
    func getTileForNumber(number: Int) -> SKTileGroup {
        switch number {
        case 0:
            return field
        default:
            return yellowBrick
        }
    }
}
