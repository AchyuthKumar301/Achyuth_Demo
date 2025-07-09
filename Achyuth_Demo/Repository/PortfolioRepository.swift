//
//  PortfolioRepository.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit


// MARK: - Repository
protocol PortfolioRepositoryProtocol {
    func getHoldings() async throws -> [Holding]
}

class PortfolioRepository: PortfolioRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getHoldings() async throws -> [Holding] {
        return try await networkService.fetchHoldings()
    }
}
