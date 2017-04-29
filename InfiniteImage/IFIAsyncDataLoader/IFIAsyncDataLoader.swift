//
//  IFIAsyncDataLoader.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
import Swinject

// MARK: - IFIAsyncDataLoader

protocol IFIAsyncDataLoader: class {

    /// Load data from a URL for a given identifier. If the same identifier is used twice, the initial load will
    /// cancel, and a new load will begin. Once the data has been loaded, the completion block is called.
    ///
    /// - note: The completion block is not called on the main queue.
    ///
    /// - parameter url: The URL to load the data from.
    /// - parameter identifier: An identifier used to identify a unique load operation.
    /// - parameter completion: Called once the data has been loaded. Not called on the main queue.
    /// - parameter data: The data that has been loaded from the URL.
    func loadData(from url: URL, withIdentifier identifier: Int, completion: @escaping (_ data: Data) -> Void)
}

// MARK: - IFIDefaultAsyncDataLoader

class IFIDefaultAsyncDataLoader {
    fileprivate let session: IFIURLSession

    fileprivate let queue = OperationQueue()
    fileprivate var currentOperations = [Int : Operation]()

    init(session: IFIURLSession) {
        self.session = session
    }
}

// MARK: IFIAsyncDataLoader Methods

extension IFIDefaultAsyncDataLoader: IFIAsyncDataLoader {

    func loadData(from url: URL, withIdentifier identifier: Int, completion: @escaping (Data) -> Void) {
        if let existingOperation = currentOperations[identifier] {
            existingOperation.cancel()
        }
        let operation = IFIDataLoaderOperation(url: url, session: session, completion: completion)

        currentOperations[identifier] = operation
        queue.addOperation(operation)
    }
}

// MAKR: - IFIAsyncDataLoaderAssembly

class IFIAsyncDataLoaderAssembly: Assembly {

    func assemble(container: Container) {
        container.register(IFIAsyncDataLoader.self) { r in
            let session = r.resolve(IFIURLSession.self)!

            return IFIDefaultAsyncDataLoader(session: session)
        }
    }
}
