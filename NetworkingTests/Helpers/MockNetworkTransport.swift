//
//  MockNetworkTransport.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
@testable import Networking

final class MockNetworkTransport: NetworkTransport {
    private let result: Result<(Data, URLResponse), Error>

    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }

    func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try result.get()
    }
}
