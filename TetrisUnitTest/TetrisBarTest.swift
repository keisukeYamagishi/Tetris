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
        assertArraysEqual(array1: TestData, array2: funya)
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
        assertArraysEqual(array1: TestData, array2: gfunya)
    }

    func testBarKagi() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 0, 1, 0],
                        [0, 0, 1, 0]]
        assertArraysEqual(array1: TestData, array2: kagi)
    }

    func testBarLKagi() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: lKagi)
    }

    func testBarWBar() throws {
        let TestData = [[1, 1, 0, 0],
                        [1, 1, 0, 0],
                        [1, 1, 0, 0],
                        [1, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: wBar)
    }

    func testBarTheOne() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: theOne)
    }

    func testBarBrew() throws {
        let TestData = [[1, 1, 1, 1],
                        [1, 1, 1, 1],
                        [1, 1, 1, 1],
                        [1, 1, 1, 1]]
        assertArraysEqual(array1: TestData, array2: brew)
    }

    func testBarLDao() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: ldao)
    }

    func testBarlRdao() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 1, 1, 0],
                        [0, 0, 1, 0]]
        assertArraysEqual(array1: TestData, array2: lRdao)
    }

    func testBarThree() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: three)
    }

    func testBarTwo() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: two)
    }

    func testBarBlock() throws {
        let TestData = [[0, 0, 0, 0],
                        [0, 1, 1, 1],
                        [0, 1, 1, 1],
                        [0, 1, 1, 1]]
        assertArraysEqual(array1: TestData, array2: block)
    }

    func testBarLongLagi() throws {
        let TestData = [[0, 1, 1, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: longLagi)
    }

    func testBarLongRKagi() throws {
        let TestData = [[1, 1, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]]
        assertArraysEqual(array1: TestData, array2: longRKagi)
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
