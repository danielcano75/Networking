//
//  URLRequestBuilderTests.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
import Testing
@testable import Networking

struct URLRequestBuilderTests {

    private let baseURL = URL(string: "https://api.example.com")!
    private let builder = URLRequestBuilder()

    private func makeConfiguration(
        timeout: TimeInterval = 30,
        defaultHeaders: [String: String] = [:]
    ) -> NetworkConfiguration {
        NetworkConfiguration(baseURL: baseURL, timeout: timeout, defaultHeaders: defaultHeaders)
    }

    // MARK: - URL

    @Test func buildCreatesCorrectURL() throws {
        let endpoint = MockEndpoint(path: "/users")
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        #expect(request.url?.absoluteString == "https://api.example.com/users")
    }

    @Test func buildAppendsQueryItemsToURL() throws {
        let endpoint = MockEndpoint(path: "/search", queryItems: [URLQueryItem(name: "q", value: "swift")])
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems?.contains(URLQueryItem(name: "q", value: "swift")) == true)
    }

    @Test func buildOmitsQueryItemsWhenNil() throws {
        let endpoint = MockEndpoint(path: "/users", queryItems: nil)
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems == nil)
    }

    @Test func buildOmitsQueryItemsWhenEmpty() throws {
        let endpoint = MockEndpoint(path: "/users", queryItems: [])
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        #expect(components?.queryItems == nil)
    }

    // MARK: - HTTP Method

    @Test func buildSetsHTTPMethod() throws {
        let endpoint = MockEndpoint(path: "/users", method: .post)
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        #expect(request.httpMethod == "POST")
    }

    @Test func buildSetsDefaultGETMethod() throws {
        let request = try builder.build(from: MockEndpoint(), configuration: makeConfiguration())
        #expect(request.httpMethod == "GET")
    }

    // MARK: - Body

    @Test func buildSetsHTTPBody() throws {
        let body = Data("{\"key\":\"value\"}".utf8)
        let endpoint = MockEndpoint(path: "/users", method: .post, body: body)
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        #expect(request.httpBody == body)
    }

    @Test func buildSetsNilBodyWhenEndpointBodyIsNil() throws {
        let request = try builder.build(from: MockEndpoint(), configuration: makeConfiguration())
        #expect(request.httpBody == nil)
    }

    // MARK: - Headers

    @Test func buildSetsDefaultHeadersFromConfiguration() throws {
        let config = makeConfiguration(defaultHeaders: ["Authorization": "Bearer token"])
        let request = try builder.build(from: MockEndpoint(), configuration: config)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token")
    }

    @Test func buildSetsEndpointHeaders() throws {
        let endpoint = MockEndpoint(path: "/users", headers: ["X-Custom": "value"])
        let request = try builder.build(from: endpoint, configuration: makeConfiguration())
        #expect(request.value(forHTTPHeaderField: "X-Custom") == "value")
    }

    @Test func buildEndpointHeadersOverrideDefaultHeaders() throws {
        let config = makeConfiguration(defaultHeaders: ["X-Header": "default"])
        let endpoint = MockEndpoint(path: "/users", headers: ["X-Header": "override"])
        let request = try builder.build(from: endpoint, configuration: config)
        #expect(request.value(forHTTPHeaderField: "X-Header") == "override")
    }

    // MARK: - Timeout

    @Test func buildSetsTimeoutFromConfiguration() throws {
        let config = makeConfiguration(timeout: 60)
        let request = try builder.build(from: MockEndpoint(), configuration: config)
        #expect(request.timeoutInterval == 60)
    }
}
