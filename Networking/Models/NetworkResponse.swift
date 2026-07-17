//
//  NetworkResponse.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

public struct NetworkResponse<Value: Sendable>: Sendable {
    public let value: Value
    public let statusCode: Int
    public let headers: [AnyHashable: Any]

    public init(
        value: Value,
        statusCode: Int,
        headers: [AnyHashable: Any]
    ) {
        self.value = value
        self.statusCode = statusCode
        self.headers = headers
    }
}
