//
//  URLRequestBuilding.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

protocol URLRequestBuilding {
    func build(
        from endpoint: Endpoint,
        configuration: NetworkConfiguration
    ) throws -> URLRequest
}
