//
//  NetworkService.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit

// MARK: - Network Layer
protocol NetworkServiceProtocol {
    func fetchHoldings() async throws -> [Holding]
}

class NetworkService: NetworkServiceProtocol {
    private let session = URLSession.shared
    private let baseURL = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    
    func fetchHoldings() async throws -> [Holding] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.BadHttpResponse
        }

        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(HoldingResponse.self, from: data)
            print(" Decoded: \(decoded)")
            return decoded.dataResponse.userHolding
        } catch {
            print("Raw JSON: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
            throw error
        }
    }

}

enum NetworkError: Error {
    case invalidURL
    case BadHttpResponse
    case noData
}
