//
//  URLSessionTransport.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

final class URLSessionTransport: NetworkTransport {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
