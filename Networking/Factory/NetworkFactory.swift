//
//  NetworkFactory.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

public enum NetworkFactory {
    static func create(with configuration: NetworkConfiguration) -> APIClientProtocol {
        APIClient(configuration: configuration)
    }
}
