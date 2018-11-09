//
//  tetrisTests.swift
//  tetrisTests
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import XCTest
@testable import tetris

class arrayTests: XCTestCase {

    var testArray: Array2D!
    var testArrayWithSix: Array2D!
    let testColumns = 5
    let testRows = 5
    let testInitNumber = 6

    override func setUp() {
        super.setUp()
        testArray = Array2D(columns: testColumns, rows: testRows)
        testArray[0,0] = 1
        testArray[0,4] = 1
        testArray[3,3] = 1

        testArrayWithSix = Array2D(columns: testColumns, rows: testRows, initialNumber: testInitNumber)
    }

    override func tearDown() {
        testArray = nil
        testArrayWithSix = nil
        super.tearDown()
    }

    func testClear() {
        testArray.clear()
        XCTAssertTrue(testArray.array.filter({ $0 == 0 }).count == testArray.array.count)
    }

    func testClearWithInitialNumber() {
        testArray.clear(with: testInitNumber)
        XCTAssertTrue(testArray.array.filter({ $0 == testInitNumber }).count == testArray.array.count)
    }

    func testSubscript() {
        let testRowIndex = 4
        let testColIndex = 4
        let testValue = 11
        testArray[testColIndex, testRowIndex] = testValue
        XCTAssertTrue(testArray.array[testRowIndex*testColumns + testColIndex] == testValue)
    }

    func testInitialNumber() {
        XCTAssertTrue(testArrayWithSix.array.filter({ $0 == testInitNumber }).count == testArrayWithSix.array.count)
    }
}
