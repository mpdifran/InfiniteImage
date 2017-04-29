//
//  IFIURLSession.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
import Swinject

// MARK: - IFIURLSession

protocol IFIURLSession: class {

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> IFIURLSessionDataTask
}

// MARK: - URLSession Extension

extension URLSession: IFIURLSession {

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> IFIURLSessionDataTask {
        // Provide a type for the task in order to call the real implementation.
        let task: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
}

// MARK: - IFIURLSessionAssembly

class IFIURLSessionAssembly: Assembly {

    func assemble(container: Container) {
        container.register(IFIURLSession.self, factory: { r in
            return URLSession.shared
        }).inObjectScope(.container)
    }
}
