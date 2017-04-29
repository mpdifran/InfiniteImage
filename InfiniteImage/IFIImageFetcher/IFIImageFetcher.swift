//
//  IFIImageFetcher.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
import Swinject

let IFIImageFetcherErrorDomain = "IFIImageFetcherErrorDomain"

enum IFIImageFetcherErrorCode: Int {
    case noData
    case jsonParsingIssue
}

// MARK: - IFIImage

struct IFIImage {
    let thumbnailURL: URL
    let contentURL: URL
}

// MARK: - IFIImageFetcher

protocol IFIImageFetcher: class {

    func fetchImages(atPage page: UInt, completion: @escaping ([IFIImage], Error?) -> Void)
}

// MARK: - IFIDefaultImageFetcher

class IFIDefaultImageFetcher {
    let urlSession: IFIURLSession
    let requestProvider: IFIURLRequestProvider

    fileprivate var runningTasks = [UInt : IFIURLSessionDataTask]()

    init(urlSession: IFIURLSession, requestProvider: IFIURLRequestProvider) {
        self.urlSession = urlSession
        self.requestProvider = requestProvider
    }
}

// MARK: IFIImageFetcher Methods

extension IFIDefaultImageFetcher: IFIImageFetcher {

    func fetchImages(atPage page: UInt, completion: @escaping ([IFIImage], Error?) -> Void) {
        guard runningTasks[page] == nil else { return }
        guard let request = requestProvider.imageRequest(atPage: page) else { return }

        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    self?.runningTasks[page] = nil
                }
            }

            if let error = error {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    let error = NSError(code: .noData)
                    completion([], error)
                }
                return
            }

            guard let json = self?.jsonObject(from: data) else {
                DispatchQueue.main.async {
                    let error = NSError(code: .jsonParsingIssue)
                    completion([], error)
                }
                return
            }

            guard let imageObjects = json["value"] as? [[String : Any]] else {
                DispatchQueue.main.async {
                    completion([], nil)
                }
                return
            }

            var images = [IFIImage]()
            for imageObject in imageObjects {
                if let image = self?.imageFromJson(json: imageObject) {
                    images.append(image)
                }
            }

            DispatchQueue.main.async {
                completion(images, nil)
            }
        }
        task.resume()

        runningTasks[page] = task
    }
}

// MARK: Private Methods

private extension IFIDefaultImageFetcher {

    func jsonObject(from data: Data) -> [String : Any]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        return json as? [String : Any]
    }

    func imageFromJson(json: [String : Any]) -> IFIImage? {
        guard let thumbnailURLString = json["thumbnailUrl"] as? String,
            let contentURLString = json["contentUrl"] as? String else { return nil }

        guard let thumbnailURL = URL(string: thumbnailURLString),
            let contentURL = URL(string: contentURLString) else { return nil }

        return IFIImage(thumbnailURL: thumbnailURL, contentURL: contentURL)
    }
}

// MARK: - NSError Extension

private extension NSError {

    convenience init(code: IFIImageFetcherErrorCode) {
        self.init(domain: IFIImageFetcherErrorDomain, code: code.rawValue, userInfo: nil)
    }
}

// MARK: - IFIImageFetcherAssembly

class IFIImageFetcherAssembly: Assembly {

    func assemble(container: Container) {
        container.register(IFIImageFetcher.self) { r in
            let session = r.resolve(IFIURLSession.self)!
            let requestProvider = r.resolve(IFIURLRequestProvider.self)!

            return IFIDefaultImageFetcher(urlSession: session, requestProvider: requestProvider)
        }
    }
}
