//
//  NetworkConfiguration.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

public struct NetworkConfiguration {
    let baseURL: URL
    let timeout: TimeInterval
    let defaultHeaders: [String: String]

    public init(
        baseURL: URL,
        timeout: TimeInterval = 30,
        defaultHeaders: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.timeout = timeout
        self.defaultHeaders = defaultHeaders
    }
}
