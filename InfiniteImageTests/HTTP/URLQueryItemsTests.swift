//
//  URLQueryItemsTests.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import XCTest
@testable import InfiniteImage

class URLQueryItemsTests: XCTestCase {
    var sut: URL!

    // MARK: - SetUp / TearDown

    override func setUp() {
        super.setUp()

        sut = URL(string: "www.apple.com")
    }
    
    // MARK: - Test Methods

    // MARK: adding

    func test_adding_multipleQueryItems_appendsToEndOfURL() {
        // Arrange
        let queryItems = [URLQueryItem(name: "first", value: "1"), URLQueryItem(name: "second", value: "2")]

        // Act
        let result = sut.adding(queryItems)

        // Assert
        XCTAssertEqual("first=1&second=2", result?.query)
    }

    func test_adding_existingQueryItems_combinesNewQueryItemsWithExisting() {
        // Arrange
        sut = sut.adding([URLQueryItem(name: "first", value: "1"), URLQueryItem(name: "second", value: "2")])
        let queryItems = [URLQueryItem(name: "third", value: "3")]

        // Act
        let result = sut.adding(queryItems)

        // Assert
        XCTAssertEqual("first=1&second=2&third=3", result?.query)
    }
}
