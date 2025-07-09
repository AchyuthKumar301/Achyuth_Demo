//
//  HoldingModel.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit


struct HoldingResponse: Codable {
    let dataResponse: HoldingData

    // Map "data" key in JSON to "dataResponse"
    enum CodingKeys: String, CodingKey {
        case dataResponse = "data"
    }
}

struct HoldingData: Codable {
    let userHolding: [Holding]
}

struct Holding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}
