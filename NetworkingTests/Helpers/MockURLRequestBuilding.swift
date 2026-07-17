//
//  MockURLRequestBuilding.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
@testable import Networking

struct MockURLRequestBuilding: URLRequestBuilding {
    private let stubbedRequest: URLRequest
    private let stubbedError: Error?

    init(
        request: URLRequest = URLRequest(url: URL(string: "https://example.com")!),
        error: Error? = nil
    ) {
        self.stubbedRequest = request
        self.stubbedError = error
    }

    func build(from endpoint: Endpoint, configuration: NetworkConfiguration) throws -> URLRequest {
        if let stubbedError { throw stubbedError }
        return stubbedRequest
    }
}
