//
//  IFIURLSessionMock.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
@testable import InfiniteImage

// MARK: - IFIURLSessionMock

class IFIURLSessionMock: IFIURLSession {
    var dataTaskMock = IFIURLSessionDataTaskMock()

    var lastRequest: URLRequest?
    var lastURL: URL?
    var lastCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> IFIURLSessionDataTask {

        lastRequest = request
        lastCompletionHandler = completionHandler

        return dataTaskMock
    }

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> IFIURLSessionDataTask {
        lastURL = url
        lastCompletionHandler = completionHandler

        return dataTaskMock
    }
}
