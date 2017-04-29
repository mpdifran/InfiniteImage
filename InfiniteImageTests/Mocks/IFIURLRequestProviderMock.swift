//
//  IFIURLRequestProviderMock.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
@testable import InfiniteImage

// MARK: - IFIURLRequestProviderMock

class IFIURLRequestProviderMock: IFIURLRequestProvider{
    var requestToReturn: URLRequest? = URLRequest(url: URL(string: "www.apple.com")!)

    var lastPage: UInt?

    func imageRequest(atPage page: UInt) -> URLRequest? {
        lastPage = page

        return requestToReturn
    }
}
