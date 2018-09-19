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

class GameScene: SKScene {

    var gameField: SKTileMapNode!
    let columns = 24
    let rows = 27
    let width = 40
    let height = 40

    var gameMatrix: Array2D!
    var pieces = [Piece]()

    var tileSet: SKTileSet!
    var yellowBrick: SKTileGroup!
    var field: SKTileGroup!

    var index = 15 // for testing
    override func didMove(to view: SKView) {
        self.view?.preferredFramesPerSecond = 1

        gameMatrix = Array2D(columns: columns, rows: rows)
        setupPices()
        setupTiles()

        gameField = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: CGSize(width: width, height: height))
        addChild(gameField)
    }
    override func update(_ currentTime: TimeInterval) {

        if index > 0 {
            if canMove(piece: pieces[0], from: (column: 6, row: index), to: (destinationCol: 6, DestinationRow: index - 1)) {
                move(piece: pieces[0], from: (column: 6, row: index), to: (column: 6, row: index - 1))
                index -= 1
                
                updateGameField()
            }
        }
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
        jPiece[1,0] = 2
        jPiece[1,1] = 2
        jPiece[1,2] = 2
        jPiece[2,2] = 2
        
        var lPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 3)
        lPiece[1,0] = 3
        lPiece[1,1] = 3
        lPiece[1,2] = 3
        lPiece[2,0] = 3
        
        var oPiece = Piece(array: Array2D(columns: 2, rows: 2), number: 4)
        oPiece[0,0] = 4
        oPiece[0,1] = 4
        oPiece[1,0] = 4
        oPiece[1,1] = 4

        var sPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 5)
        sPiece[0,1] = 5
        sPiece[0,2] = 5
        sPiece[1,0] = 5
        sPiece[1,1] = 5
        
        var tPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 6)
        tPiece[1,0] = 6
        tPiece[1,1] = 6
        tPiece[1,2] = 6
        tPiece[2,1] = 6

        var zPiece = Piece(array: Array2D(columns: 3, rows: 3), number: 7)
        zPiece[0,0] = 7
        zPiece[0,1] = 7
        zPiece[1,1] = 7
        zPiece[1,2] = 7

        pieces.append(iPiece)
        pieces.append(jPiece)
        pieces.append(lPiece)
        pieces.append(oPiece)
        pieces.append(sPiece)
        pieces.append(tPiece)
        pieces.append(zPiece)
    }
    
    func canMove(piece: Piece, from: (column: Int, row: Int), to: (destinationCol: Int, DestinationRow: Int)) -> Bool{
        
        let lastColumnIndex = to.destinationCol + piece.array.columns
        let lastRowIndex = to.DestinationRow + piece.array.rows
        
        for col in to.destinationCol..<lastColumnIndex {
            for row in to.DestinationRow..<lastRowIndex {
                if gameMatrix[col, row] != 0 && gameMatrix[col, row] != piece.number {return false }
            }
        }
        return true;
    }

    func move(piece: Piece, from: (column: Int, row: Int), to: (column: Int, row: Int)) {
        
        let fromLastCol = from.column + piece.array.columns
        let fromLastRow = from.row + piece.array.rows
        for col in from.column..<fromLastCol {
            for row in from.row..<fromLastRow {
                if gameMatrix[col, row] == piece.number {
                    gameMatrix[col, row] = 0
                }
            }
        }
        
        let toLastCol = to.column + piece.array.columns
        let toLastRow = to.row + piece.array.rows
        for col in to.column..<toLastCol {
            for row in to.row..<toLastRow {
                if piece[col - to.column, row - to.row] == piece.number {
                    gameMatrix[col, row] = piece.number
                }
            }
        }
    }

    func updateGameField() {
        for col in 0..<columns {
            for row in 0..<rows {
                gameField.setTileGroup(getTileForNumber(number: gameMatrix[col, row]), forColumn: col, row: row)
            }
        }
    }
    
    func getTileForNumber(number: Int) -> SKTileGroup {
        switch number {
        case 1:
            return yellowBrick
        default:
            return field
        }
    }
}
