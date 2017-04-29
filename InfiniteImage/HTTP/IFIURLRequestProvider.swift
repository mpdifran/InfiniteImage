//
//  IFIURLRequestProvider.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
import Swinject

// MARK: - IFIURLRequestProvider

protocol IFIURLRequestProvider: class {

    func imageRequest(atPage page: UInt) -> URLRequest?
}

// MARK: - IFIDefaultURLRequestProvider

class IFIDefaultURLRequestProvider { }

// MARK: IFIURLRequestProvider Methods

extension IFIDefaultURLRequestProvider: IFIURLRequestProvider {

    func imageRequest(atPage page: UInt) -> URLRequest? {
        guard let url = BaseURL.imageSearchURL.adding([
            URLQueryItem(name: Key.Query.searchTerm, value: "rock climbing"),
            URLQueryItem(name: Key.Query.count, value: "50"),
            URLQueryItem(name: Key.Query.offset, value: "\(page)"),
            URLQueryItem(name: Key.Query.market, value: Value.Query.enUs),
            URLQueryItem(name: Key.Query.safeSearch, value: Value.Query.moderate)
            ]) else {
                return nil
        }

        var request = URLRequest(url: url)
        request.addValue(Value.apiKey, forHTTPHeaderField: Key.Header.subscription)

        return request
    }
}

// MARK: - BaseURL

private struct BaseURL {
    static let imageSearchURL = URL(string: "https://api.cognitive.microsoft.com/bing/v5.0/images/search")!

    private init() { }
}

// MARK: - Key

private struct Key {

    struct Header {
        static let subscription = "Ocp-Apim-Subscription-Key"

        private init() { }
    }

    struct Query {
        static let searchTerm = "q"
        static let count = "count"
        static let offset = "offset"
        static let market = "mkt"
        static let safeSearch = "safeSearch"

        private init() { }
    }

    private init() { }
}

// MARK: - Value

private struct Value {
    static let apiKey = "5db7a77b19d943f2a4cce83ce6b59502"

    struct Query {
        static let enUs = "en-us"
        static let moderate = "Moderate"

        private init() { }
    }
    
    private init() { }
}

// MARK: - IFIURLRequestProviderAssembly

class IFIURLRequestProviderAssembly: Assembly {

    func assemble(container: Container) {
        container.register(IFIURLRequestProvider.self, factory: { r in
            return IFIDefaultURLRequestProvider()
        }).inObjectScope(.weak)
    }
}
