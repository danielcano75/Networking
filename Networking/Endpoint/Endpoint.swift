//
//  Endpoint.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}
