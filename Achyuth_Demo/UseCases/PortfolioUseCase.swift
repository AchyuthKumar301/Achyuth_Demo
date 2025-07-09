//
//  PortfolioUseCase.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit

// MARK: - Use Cases
protocol PortfolioUseCaseProtocol {
    func getPortfolioData() async throws -> ([HoldingViewModel], PortfolioSummary)
}

class PortfolioUseCase: PortfolioUseCaseProtocol {
    private let repository: PortfolioRepositoryProtocol
    
    init(repository: PortfolioRepositoryProtocol = PortfolioRepository()) {
        self.repository = repository
    }
    
    func getPortfolioData() async throws -> ([HoldingViewModel], PortfolioSummary) {
        let holdings = try await repository.getHoldings()
        let viewModels = createHoldingViewModels(from: holdings)
        let summary = calculatePortfolioSummary(from: holdings)
        return (viewModels, summary)
    }
    
    private func createHoldingViewModels(from holdings: [Holding]) -> [HoldingViewModel] {
        return holdings.map { holding in
            let pnl = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
            return HoldingViewModel(
                symbol: holding.symbol,
                quantity: holding.quantity,
                ltp: holding.ltp,
                pnl: pnl
            )
        }
    }
    
    private func calculatePortfolioSummary(from holdings: [Holding]) -> PortfolioSummary {
        let currentValue = holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
        let totalInvestment = holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        let totalPNL = currentValue - totalInvestment
        let todaysPNL = holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
        
        return PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPNL: totalPNL,
            todaysPNL: todaysPNL
        )
    }
}
