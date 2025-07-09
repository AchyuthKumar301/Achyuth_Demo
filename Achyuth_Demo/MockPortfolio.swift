//
//  MockPortfolio.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Combine

// MARK: - Mock Classes for Testing
class MockPortfolioRepository: PortfolioRepositoryProtocol {
    var holdingsToReturn: [Holding] = []
    var shouldThrowError = false
    
    func getHoldings() async throws -> [Holding] {
        if shouldThrowError {
            throw MockError.testError
        }
        return holdingsToReturn
    }
}

class MockPortfolioUseCase: PortfolioUseCaseProtocol {
    var dataToReturn: ([HoldingViewModel], PortfolioSummary)!
    var shouldThrowError = false
    
    func getPortfolioData() async throws -> ([HoldingViewModel], PortfolioSummary) {
        if shouldThrowError {
            throw MockError.testError
        }
        return dataToReturn
    }
}

enum MockError: Error {
    case testError
}

extension Published.Publisher {
    var values: AsyncStream<Output> {
        AsyncStream { continuation in
            let cancellable = self.sink { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }
}
