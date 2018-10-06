//
//  Piece.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 10. 06..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

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
        let newArray = Array2D(columns: array.columns, rows: array.rows)
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
