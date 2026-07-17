//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

struct URLRequestBuilder: URLRequestBuilding {
    func build(
        from endpoint: Endpoint,
        configuration: NetworkConfiguration
    ) throws -> URLRequest {
        guard var components = URLComponents(
            url: configuration.baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = endpoint.queryItems?.isEmpty == false
            ? endpoint.queryItems
            : nil

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)

        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = configuration.timeout

        configuration.defaultHeaders.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        endpoint.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        return request
    }
}
