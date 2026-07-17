//
//  NetworkTransport.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

protocol NetworkTransport {
    func send(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse)
}
