//
//  IFIURLProvider.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation

// MARK: - IFIURLProvider

protocol IFIURLProvider: class {
    var imageSearchURL: URL { get }
}

// MARK: - IFIDefaultURLProvider

class IFIDefaultURLProvider {
    let imageSearchURL = URL(string: "https://api.cognitive.microsoft.com/bing/v5.0/images/search")!
}

// MARK: IFIURLProvider Methods

extension IFIDefaultURLProvider: IFIURLProvider { }
