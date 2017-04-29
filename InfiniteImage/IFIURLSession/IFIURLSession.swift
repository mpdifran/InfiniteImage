//
//  IFIURLSession.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation

// MARK: - IFIURLSession

protocol IFIURLSession: class {
    func dataTask(with request: URLRequest) -> IFIURLSessionDataTask
}

// MARK: - URLSession Extension

extension URLSession: IFIURLSession {

    func dataTask(with request: URLRequest) -> IFIURLSessionDataTask {
        // Provide a type for the task in order to call the real implementation.
        let task: URLSessionDataTask = dataTask(with: request)
        return task
    }
}
