//
//  HTTPMethod.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case head    = "HEAD"
    case options = "OPTIONS"
}
