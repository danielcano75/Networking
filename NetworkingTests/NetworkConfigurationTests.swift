//
//  NetworkConfigurationTests.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
import Testing
@testable import Networking

struct NetworkConfigurationTests {

    private let baseURL = URL(string: "https://api.example.com")!

    @Test func initStoresBaseURL() {
        let config = NetworkConfiguration(baseURL: baseURL)
        #expect(config.baseURL == baseURL)
    }

    @Test func initUsesDefaultTimeout() {
        let config = NetworkConfiguration(baseURL: baseURL)
        #expect(config.timeout == 30)
    }

    @Test func initUsesEmptyDefaultHeaders() {
        let config = NetworkConfiguration(baseURL: baseURL)
        #expect(config.defaultHeaders.isEmpty)
    }

    @Test func initStoresCustomTimeout() {
        let config = NetworkConfiguration(baseURL: baseURL, timeout: 60)
        #expect(config.timeout == 60)
    }

    @Test func initStoresCustomDefaultHeaders() {
        let headers = ["Authorization": "Bearer token", "Accept": "application/json"]
        let config = NetworkConfiguration(baseURL: baseURL, defaultHeaders: headers)
        #expect(config.defaultHeaders == headers)
    }
}
