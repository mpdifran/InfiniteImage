//
//  IFIImageFetcherTests.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import XCTest
@testable import InfiniteImage

class IFIImageFetcherTests: XCTestCase {
    var sut: IFIImageFetcher!

    var sessionMock: IFIURLSessionMock!
    var requestProviderMock: IFIURLRequestProviderMock!

    let successResponse = HTTPURLResponse(url: URL(string: "www.apple.com")!, statusCode: 200, httpVersion: nil,
                                          headerFields: nil)
    let jsonData: Data = {
        return "{\"value\":[{\"contentUrl\":\"www.contentUrl.com\", \"thumbnailUrl\":\"www.thumbnailUrl.com\"}]}".data(using: .utf8)!
    }()

    // MARK: - SetUp / TearDown

    override func setUp() {
        super.setUp()

        sessionMock = IFIURLSessionMock()
        requestProviderMock = IFIURLRequestProviderMock()

        sut = IFIDefaultImageFetcher(urlSession: sessionMock, requestProvider: requestProviderMock)
    }
    
    // MARK: - Test Methods

    // MARK: fetchImages

    func test_fetchImages_taskAlreadyRunningForPage_requestIsNotMade() {
        // Arrange
        sut.fetchImages(atPage: 1) { (_, _) in }
        sessionMock.lastRequest = nil
        sessionMock.dataTaskMock = IFIURLSessionDataTaskMock()

        // Act
        sut.fetchImages(atPage: 1) { (_, _) in }

        // Assert
        XCTAssertNil(sessionMock.lastRequest)
    }

    func test_fetchImages_requestIsNil_noRequestIsMade() {
        // Arrange
        requestProviderMock.requestToReturn = nil

        // Act
        sut.fetchImages(atPage: 0) { (_, _) in }

        // Assert
        XCTAssertNil(sessionMock.lastRequest)
    }

    func test_fetchImages_taskIsResumed() {
        // Arrange
        // Act
        sut.fetchImages(atPage: 0) { (_, _) in }

        // Assert
        XCTAssertTrue(sessionMock.dataTaskMock.didResume)
    }

    func test_fetchImages_encounteredError_errorPassedToCompletion() {
        // Arrange
        let exp = expectation(description: "\(#function)-\(#line)")
        let expectedError = NSError(domain: "Test", code: 1, userInfo: nil)
        sut.fetchImages(atPage: 0) { (images, error) in
            XCTAssertEqual(expectedError, error! as NSError)
            exp.fulfill()
        }

        // Act
        sessionMock.lastCompletionHandler?(nil, successResponse, expectedError)

        // Assert
        waitForExpectations(timeout: 1, handler: nil)
    }

    // There are a few other error tests I could add, but I'll leave out in the interest of time.

    func test_fetchImages_successfulResponse_imagesPassedToCompletion() {
        // Arrange
        let exp = expectation(description: "\(#function)-\(#line)")
        sut.fetchImages(atPage: 0) { (images, error) in
            XCTAssertEqual(1, images.count)
            let image = images.first
            XCTAssertEqual("www.contentUrl.com", image?.contentURL.absoluteString)
            XCTAssertEqual("www.thumbnailUrl.com", image?.thumbnailURL.absoluteString)
            exp.fulfill()
        }

        // Act
        sessionMock.lastCompletionHandler?(jsonData, successResponse, nil)

        // Assert
        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_fetchImages_canFetchTheSamePageMultipleTimes() {
        // Arrange
        let exp = expectation(description: "\(#function)-\(#line)")
        sut.fetchImages(atPage: 1) { (_, _) in exp.fulfill() }
        sessionMock.lastCompletionHandler?(jsonData, successResponse, nil)
        waitForExpectations(timeout: 1, handler: nil)
        sessionMock.dataTaskMock = IFIURLSessionDataTaskMock()

        // Act
        sut.fetchImages(atPage: 1) { (_, _) in }

        // Assert
        XCTAssertTrue(sessionMock.dataTaskMock.didResume)
    }
}
