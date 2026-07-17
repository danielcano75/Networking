//
//  MockEndpoint.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
@testable import Networking

struct MockEndpoint: Endpoint {
    var path: String = "/test"
    var method: HTTPMethod = .get
    var headers: HTTPHeaders = [:]
    var queryItems: [URLQueryItem]? = nil
    var body: Data? = nil
}
