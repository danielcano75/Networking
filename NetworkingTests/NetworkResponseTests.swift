//
//  NetworkResponseTests.swift
//  NetworkingTests
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation
import Testing
@testable import Networking

struct NetworkResponseTests {

    @Test func initStoresValue() {
        let response = NetworkResponse(value: "hello", statusCode: 200, headers: [:])
        #expect(response.value == "hello")
    }

    @Test func initStoresStatusCode() {
        let response = NetworkResponse(value: 0, statusCode: 201, headers: [:])
        #expect(response.statusCode == 201)
    }

    @Test func initStoresHeaders() {
        let headers: [AnyHashable: Any] = ["Content-Type": "application/json"]
        let response = NetworkResponse(value: 0, statusCode: 200, headers: headers)
        #expect(response.headers["Content-Type"] as? String == "application/json")
    }
}
