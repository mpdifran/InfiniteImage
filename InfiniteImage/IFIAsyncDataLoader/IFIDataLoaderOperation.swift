//
//  IFIDataLoaderOperation.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation

// MARK: - IFIDataLoaderOperation

class IFIDataLoaderOperation: Operation {

    fileprivate enum State {
        case ready
        case executing
        case finished

        fileprivate var keyPath: String {
            switch self {
            case .ready: return "isReady"
            case .executing: return "isExecuting"
            case .finished: return "isFinished"
            }
        }
    }

    fileprivate let stateQueue = DispatchQueue(label: "com.InfiniteImage.IFIDataLoaderOperation.stateQueue")
    fileprivate var state: State {
        get {
            var state = State.ready
            stateQueue.sync {
                state = self._state
            }
            return state
        }
        set {
            var oldValue = State.ready
            stateQueue.sync {
                oldValue = self._state
            }

            willChangeValue(forKey: oldValue.keyPath)
            willChangeValue(forKey: newValue.keyPath)

            stateQueue.sync {
                self._state = newValue
            }

            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: newValue.keyPath)
        }
    }
    private var _state = State.ready

    fileprivate var task: IFIURLSessionDataTask?

    fileprivate let url: URL
    fileprivate let session: IFIURLSession
    fileprivate let completion: (Data) -> Void

    init(url: URL, session: IFIURLSession, completion: @escaping (Data) -> Void) {
        self.url = url
        self.session = session
        self.completion = completion
    }
}

// MARK: State

extension IFIDataLoaderOperation {
    override var isAsynchronous: Bool {
        return true
    }
    override var isReady: Bool {
        return state == .ready && super.isReady
    }
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
}

// MARK: Instance Methods

extension IFIDataLoaderOperation {

    override func start() {
        if isCancelled {
            onCancelled()
        } else {
            state = .executing
            main()
        }
    }

    override func main() {
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            defer {
                self?.onFinished()
            }

            guard !(self?.isCancelled ?? true) else { return }
            guard let data = data else { return }

            self?.completion(data)
        }
        task.resume()

        self.task = task
    }

    func onFinished() {
        state = .finished
    }

    func onCancelled() {
        onFinished()
    }
}
