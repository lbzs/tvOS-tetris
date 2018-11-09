//
//  pieceTests.swift
//  tetrisTests
//
//  Created by Balint Zsombor Lakatos on 2018. 11. 06..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import XCTest
@testable import tetris

class pieceTests: XCTestCase {
    
    var testIPiece: Piece!
    var testPieceRotatedLeft: Piece!
    var testPieceRotatedRight: Piece!
    
    override func setUp() {
        super.setUp()

        testIPiece = Piece(array: Array2D(columns: 4, rows: 4), number: 1)
        testIPiece[1,0] = 1
        testIPiece[1,1] = 1
        testIPiece[1,2] = 1
        testIPiece[1,3] = 1

        testPieceRotatedLeft = Piece(array: Array2D(columns: 4, rows: 4), number: 1)
        testPieceRotatedLeft[0,1] = 1
        testPieceRotatedLeft[1,1] = 1
        testPieceRotatedLeft[2,1] = 1
        testPieceRotatedLeft[3,1] = 1

        testPieceRotatedRight = Piece(array: Array2D(columns: 4, rows: 4), number: 1)
        testPieceRotatedRight[0,2] = 1
        testPieceRotatedRight[1,2] = 1
        testPieceRotatedRight[2,2] = 1
        testPieceRotatedRight[3,2] = 1
    }
    
    override func tearDown() {
        testIPiece = nil
        testPieceRotatedLeft = nil
        testPieceRotatedRight = nil
        super.tearDown()
    }

    func testRotateLeft() {
        testIPiece.rotate(direction: .left)
        XCTAssertTrue(testIPiece.array.array == testPieceRotatedLeft.array.array)
    }

    func testRotateRigth() {
        testIPiece.rotate(direction: .right)
        XCTAssertTrue(testIPiece.array.array == testPieceRotatedRight.array.array)
    }
}
