//
//  IFIURLSessionTask.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation

// MARK: - IFIURLSessionTask

protocol IFIURLSessionTask: class {

    func resume()
    func suspend()
    func cancel()
}

// MARK: - URLSessionTask Extension

extension URLSessionTask: IFIURLSessionTask { }

// MARK: - IFIURLSessionDataTask

protocol IFIURLSessionDataTask: IFIURLSessionTask { }

// MARK: - URLSessionDataTask Extension

extension URLSessionDataTask: IFIURLSessionDataTask { }
