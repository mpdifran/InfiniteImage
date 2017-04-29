//
//  URL+QueryItems.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation

extension URL {

    /// Adds the provided query items to the url's existing query items, and returns the new URL. Returns nil if the 
    /// new URL cannot be constructed.
    ///
    /// - parameter queryItems: The query items to add to the URL.
    /// - returns: A new URL with the query items appended.
    func adding(_ queryItems: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }

        var existingQueryItems = components.queryItems ?? [URLQueryItem]()
        existingQueryItems.append(contentsOf: queryItems)
        components.queryItems = existingQueryItems

        return components.url
    }
}
