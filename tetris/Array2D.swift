//  Array2D.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 29..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

class Array2D {
    let columns: Int
    let rows: Int
    var array: Array<Int>
    
    init(columns: Int, rows: Int, initialNumber: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<Int>(repeating: initialNumber, count: rows * columns)
    }

    convenience init(columns: Int, rows: Int) {
        self.init(columns: columns, rows: rows, initialNumber: 0)
    }
    
    subscript(column: Int, row: Int) -> Int {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }

    func clear(with initialNumber: Int = 0) {
        array = Array<Int>(repeating: initialNumber, count: rows * columns)
    }
}
