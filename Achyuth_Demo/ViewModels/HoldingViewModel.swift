//
//  HoldingViewModel.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit

struct HoldingViewModel {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let pnl: Double
    
    var formattedLTP: String {
        return "₹\(String(format: "%.2f", ltp))"
    }
    
    var formattedPNL: String {
        let prefix = pnl >= 0 ? "₹" : "-₹"
        return "\(prefix)\(String(format: "%.2f", abs(pnl)))"
    }
    
    var pnlColor: UIColor {
        return pnl >= 0 ? .systemGreen : .systemRed
    }
}
