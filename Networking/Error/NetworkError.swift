//
//  NetworkError.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

enum NetworkError: Error, Sendable {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case httpError(
        statusCode: Int,
        data: Data?
    )
    case decoding(Error)
    case encoding(Error)
    case cancelled
    case timeout
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .transport(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpError(let statusCode, _):
            return "HTTP Error (\(statusCode))."
        case .decoding(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .encoding(let error):
            return "Encoding failed: \(error.localizedDescription)"
        case .cancelled:
            return "The request was cancelled."
        case .timeout:
            return "The request timed out."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
