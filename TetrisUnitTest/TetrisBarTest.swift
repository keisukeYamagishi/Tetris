//
//  TetrisBarTest.swift
//  TetrisUnitTest
//
//  Created by keisuke yamagishi on 2023/06/21.
//  Copyright © 2023 shichimitoucarashi. All rights reserved.
//

@testable import Tetris
import XCTest

final class TetrisBarTest: XCTestCase {
    func testBarShikaku() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 1, 1, 0]]
        assertArraysEqual(array1: TestData, array2: shikaku)
    }

    func testBarFunya() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 1, 0],
                        [0, 0, 1, 0]]
        assertArraysEqual(array1: TestData, array2: sBar)
    }

    func testBarBou() throws {
        let TestData = [[0, 0, 1, 0],
                        [0, 0, 1, 0],
                        [0, 0, 1, 0],
                        [0, 0, 1, 0]]
        assertArraysEqual(array1: TestData, array2: bou)
    }

    func testBarYama() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 1, 0, 0],
                        [1, 1, 1, 0]]
        assertArraysEqual(array1: TestData, array2: yama)
    }

    func testBarGfunya() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 1, 0],
                        [0, 1, 1, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: zBar)
    }

    func testBarKagi() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 0, 1, 0],
                        [0, 0, 1, 0]]
        assertArraysEqual(array1: TestData, array2: lBar)
    }

    func testBarLKagi() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: jBar)
    }

    private func assertArraysEqual(array1: [[Int]],
                                   array2: [[Int]])
    {
        XCTAssert(array1.count == array2.count)

        for index in 0 ..< array1.count {
            XCTAssert(array1[index].count == array2[index].count)
        }

        for index in 0 ..< array1.count {
            let testData = array1[index]
            let appData = array2[index]

            for index2 in 0 ..< testData.count {
                if testData[index2] != appData[index2] {
                    XCTFail()
                }
            }
        }
    }
}
