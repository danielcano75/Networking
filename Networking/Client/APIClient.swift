//
//  APIClient.swift
//  Networking
//
//  Created by Daniel Cano on 7/17/26.
//

import Foundation

class APIClient: APIClientProtocol {
    private var configuration: NetworkConfiguration
    private var transport: NetworkTransport
    private let requestBuilder: URLRequestBuilding
    
    init(configuration: NetworkConfiguration,
         transport: NetworkTransport = URLSessionTransport(),
         requestBuilder: URLRequestBuilding = URLRequestBuilder()) {
        self.configuration = configuration
        self.transport = transport
        self.requestBuilder = requestBuilder
    }
    
    func execute<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> NetworkResponse<T> {
        let request = try requestBuilder.build(
            from: endpoint,
            configuration: configuration
        )
        
        let (data, response) = try await perform(request)
        
        let httpResponse = try validate(response)
        
        let model: T = try decode(data)
        
        return makeResponse(
            model,
            data: data,
            response: httpResponse
        )
    }
    
    private func perform(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse) {
        do {
            return try await transport.send(request)
            
        } catch let error as URLError {
            
            switch error.code {
                
            case .cancelled:
                throw NetworkError.cancelled
                
            case .timedOut:
                throw NetworkError.timeout
                
            default:
                throw NetworkError.transport(error)
            }
            
        } catch {
            
            throw NetworkError.unknown(error)
        }
    }
    
    private func validate(
        _ response: URLResponse,
        data: Data? = nil
    ) throws -> HTTPURLResponse {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= response.statusCode else {
            throw NetworkError.httpError(statusCode: response.statusCode, data: data)
        }
        
        return response
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
    
    private func makeResponse<T>(
        _ value: T,
        data: Data,
        response: HTTPURLResponse
    ) -> NetworkResponse<T> {
        
        NetworkResponse(
            value: value,
            statusCode: response.statusCode,
            headers: response.allHeaderFields
        )
    }
}
