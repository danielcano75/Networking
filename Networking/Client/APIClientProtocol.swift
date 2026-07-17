//
//  APIClientProtocol.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

protocol APIClientProtocol {
    func execute<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> NetworkResponse<T>
}
