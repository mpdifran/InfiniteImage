//
//  IFIURLSesstionTaskMock.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
@testable import InfiniteImage

// MARK: - IFIURLSessionTaskMock

class IFIURLSessionTaskMock: IFIURLSessionTask {
    var didResume = false
    var didSuspend = false
    var didCancel = false

    func resume() {
        didResume = true
    }

    func suspend() {
        didSuspend = true
    }

    func cancel() {
        didCancel = true
    }
}

// MARK: - IFIURLSessionDataTaskMock

class IFIURLSessionDataTaskMock: IFIURLSessionTaskMock { }

// MARK: IFIURLSessionDataTask Methods

extension IFIURLSessionDataTaskMock: IFIURLSessionDataTask { }
