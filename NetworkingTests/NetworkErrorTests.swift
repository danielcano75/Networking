//
//  NetworkErrorTests.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
import Testing
@testable import Networking

struct NetworkErrorTests {

    @Test func invalidURLHasCorrectDescription() {
        #expect(NetworkError.invalidURL.errorDescription == "The URL is invalid.")
    }

    @Test func invalidResponseHasCorrectDescription() {
        #expect(NetworkError.invalidResponse.errorDescription == "The server returned an invalid response.")
    }

    @Test func cancelledHasCorrectDescription() {
        #expect(NetworkError.cancelled.errorDescription == "The request was cancelled.")
    }

    @Test func timeoutHasCorrectDescription() {
        #expect(NetworkError.timeout.errorDescription == "The request timed out.")
    }

    @Test func httpErrorHasCorrectDescription() {
        #expect(NetworkError.httpError(statusCode: 404, data: nil).errorDescription == "HTTP Error (404).")
    }

    @Test func transportHasCorrectDescription() {
        struct FakeError: LocalizedError {
            var errorDescription: String? { "connection refused" }
        }
        #expect(NetworkError.transport(FakeError()).errorDescription == "connection refused")
    }

    @Test func decodingHasCorrectDescription() {
        struct FakeError: LocalizedError {
            var errorDescription: String? { "invalid key" }
        }
        #expect(NetworkError.decoding(FakeError()).errorDescription == "Decoding failed: invalid key")
    }

    @Test func encodingHasCorrectDescription() {
        struct FakeError: LocalizedError {
            var errorDescription: String? { "value out of range" }
        }
        #expect(NetworkError.encoding(FakeError()).errorDescription == "Encoding failed: value out of range")
    }

    @Test func unknownHasCorrectDescription() {
        struct FakeError: LocalizedError {
            var errorDescription: String? { "something unexpected" }
        }
        #expect(NetworkError.unknown(FakeError()).errorDescription == "something unexpected")
    }
}
