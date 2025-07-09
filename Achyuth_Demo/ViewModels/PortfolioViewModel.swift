//
//  PortfolioViewModel.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit
import Combine

// MARK: - ViewModel
@MainActor
protocol PortfolioViewModelProtocol: ObservableObject {
    var holdings: [HoldingViewModel] { get }
    var portfolioSummary: PortfolioSummary? { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    // Expose Publishers for Combine-based observation
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var holdingsPublisher: Published<[HoldingViewModel]>.Publisher { get }
    var portfolioSummaryPublisher: Published<PortfolioSummary?>.Publisher { get }
    var errorMessagePublisher: Published<String?>.Publisher { get }

    func loadPortfolioData() async
}

@MainActor
class PortfolioViewModel: PortfolioViewModelProtocol {
    @Published private(set) var holdings: [HoldingViewModel] = []
    @Published private(set) var portfolioSummary: PortfolioSummary?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var holdingsPublisher: Published<[HoldingViewModel]>.Publisher { $holdings }
    var portfolioSummaryPublisher: Published<PortfolioSummary?>.Publisher { $portfolioSummary }
    var errorMessagePublisher: Published<String?>.Publisher { $errorMessage }
    
    private let useCase: PortfolioUseCaseProtocol
    
    init(useCase: PortfolioUseCaseProtocol = PortfolioUseCase()) {
        self.useCase = useCase
    }
    
    func loadPortfolioData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let (holdings, summary) = try await useCase.getPortfolioData()
            self.holdings = holdings
            self.portfolioSummary = summary
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

