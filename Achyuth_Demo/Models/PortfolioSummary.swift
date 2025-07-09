//
//  PortfolioSummary.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit

// MARK: - Domain Models
struct PortfolioSummary {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double
    
    var totalPNLPercentage: Double {
        guard totalInvestment > 0 else { return 0 }
        return (totalPNL / totalInvestment) * 100
    }
}
