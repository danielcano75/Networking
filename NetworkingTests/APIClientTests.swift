//
//  APIClientTests.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
import Testing
@testable import Networking

struct APIClientTests {

    private struct MockModel: Codable {
        let id: Int
        let name: String
    }

    private let baseURL = URL(string: "https://api.example.com")!

    private func makeConfiguration() -> NetworkConfiguration {
        NetworkConfiguration(baseURL: baseURL, timeout: 30)
    }

    private func makeHTTPResponse(statusCode: Int = 200, headerFields: [String: String]? = nil) -> HTTPURLResponse {
        HTTPURLResponse(
            url: baseURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headerFields
        )!
    }

    private func makeClient(transport: NetworkTransport) -> APIClient {
        APIClient(
            configuration: makeConfiguration(),
            transport: transport,
            requestBuilder: MockURLRequestBuilding()
        )
    }

    private func encode(_ model: MockModel) throws -> Data {
        try JSONEncoder().encode(model)
    }

    // MARK: - Happy Path

    @Test func executeReturnsDecodedValue() async throws {
        let expected = MockModel(id: 42, name: "Swift")
        let transport = MockNetworkTransport(result: .success((try encode(expected), makeHTTPResponse())))
        let client = makeClient(transport: transport)

        let response = try await client.execute(MockEndpoint(), as: MockModel.self)

        #expect(response.value.id == expected.id)
        #expect(response.value.name == expected.name)
    }

    @Test func executeMapsStatusCodeInResponse() async throws {
        let data = try encode(MockModel(id: 1, name: "test"))
        let transport = MockNetworkTransport(result: .success((data, makeHTTPResponse(statusCode: 201))))
        let client = makeClient(transport: transport)

        let response = try await client.execute(MockEndpoint(), as: MockModel.self)

        #expect(response.statusCode == 201)
    }

    @Test func executeMapsHeadersInResponse() async throws {
        let data = try encode(MockModel(id: 1, name: "test"))
        let headers = ["Content-Type": "application/json"]
        let transport = MockNetworkTransport(result: .success((data, makeHTTPResponse(headerFields: headers))))
        let client = makeClient(transport: transport)

        let response = try await client.execute(MockEndpoint(), as: MockModel.self)

        #expect(response.headers["Content-Type"] as? String == "application/json")
    }

    // MARK: - Transport Errors

    @Test func executeThrowsCancelledOnURLErrorCancelled() async {
        let client = makeClient(transport: MockNetworkTransport(result: .failure(URLError(.cancelled))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.cancelled to be thrown")
        } catch NetworkError.cancelled {
            // pass
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func executeThrowsTimeoutOnURLErrorTimedOut() async {
        let client = makeClient(transport: MockNetworkTransport(result: .failure(URLError(.timedOut))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.timeout to be thrown")
        } catch NetworkError.timeout {
            // pass
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func executeThrowsTransportOnOtherURLError() async {
        let client = makeClient(transport: MockNetworkTransport(result: .failure(URLError(.networkConnectionLost))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.transport to be thrown")
        } catch let error as NetworkError {
            guard case .transport = error else {
                Issue.record("Expected NetworkError.transport, got \(error)")
                return
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func executeThrowsUnknownOnNonURLError() async {
        struct ArbitraryError: Error {}
        let client = makeClient(transport: MockNetworkTransport(result: .failure(ArbitraryError())))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.unknown to be thrown")
        } catch let error as NetworkError {
            guard case .unknown = error else {
                Issue.record("Expected NetworkError.unknown, got \(error)")
                return
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    // MARK: - Response Validation

    @Test func executeThrowsInvalidResponseForNonHTTPResponse() async {
        let response = URLResponse(url: baseURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let client = makeClient(transport: MockNetworkTransport(result: .success((Data(), response))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.invalidResponse to be thrown")
        } catch NetworkError.invalidResponse {
            // pass
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func executeThrowsHTTPErrorOn4xx() async {
        let client = makeClient(transport: MockNetworkTransport(result: .success((Data(), makeHTTPResponse(statusCode: 404)))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.httpError to be thrown")
        } catch let error as NetworkError {
            guard case .httpError(let statusCode, _) = error, statusCode == 404 else {
                Issue.record("Expected NetworkError.httpError(404), got \(error)")
                return
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    @Test func executeThrowsHTTPErrorOn5xx() async {
        let client = makeClient(transport: MockNetworkTransport(result: .success((Data(), makeHTTPResponse(statusCode: 500)))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.httpError to be thrown")
        } catch let error as NetworkError {
            guard case .httpError(let statusCode, _) = error, statusCode == 500 else {
                Issue.record("Expected NetworkError.httpError(500), got \(error)")
                return
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }

    // MARK: - Decoding

    @Test func executeThrowsDecodingErrorOnInvalidJSON() async {
        let data = Data("not-valid-json".utf8)
        let client = makeClient(transport: MockNetworkTransport(result: .success((data, makeHTTPResponse()))))

        do {
            _ = try await client.execute(MockEndpoint(), as: MockModel.self)
            Issue.record("Expected NetworkError.decoding to be thrown")
        } catch let error as NetworkError {
            guard case .decoding = error else {
                Issue.record("Expected NetworkError.decoding, got \(error)")
                return
            }
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
