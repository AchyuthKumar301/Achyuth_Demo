//
//  HoldingCell.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import UIKit

// MARK: - Custom Views
class HoldingCell: UITableViewCell {
    static let identifier = "HoldingCell"
    
    private let symbolLabel = UILabel()
    private let quantityLabel = UILabel()
    private let ltpLabel = UILabel()
    private let pnlLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        [symbolLabel, quantityLabel, ltpLabel, pnlLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Configure labels
        symbolLabel.font = .systemFont(ofSize: 16, weight: .medium)
        symbolLabel.textColor = .label
        
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textColor = .secondaryLabel
        
        ltpLabel.font = .systemFont(ofSize: 16, weight: .medium)
        ltpLabel.textColor = .label
        ltpLabel.textAlignment = .right
        
        pnlLabel.font = .systemFont(ofSize: 14, weight: .medium)
        pnlLabel.textAlignment = .right
        
        // Setup constraints
        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            quantityLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ltpLabel.topAnchor.constraint(equalTo: symbolLabel.topAnchor),
            ltpLabel.leadingAnchor.constraint(greaterThanOrEqualTo: symbolLabel.trailingAnchor, constant: 16),
            
            pnlLabel.trailingAnchor.constraint(equalTo: ltpLabel.trailingAnchor),
            pnlLabel.topAnchor.constraint(equalTo: ltpLabel.bottomAnchor, constant: 4),
            pnlLabel.leadingAnchor.constraint(greaterThanOrEqualTo: quantityLabel.trailingAnchor, constant: 16)
        ])
    }
    
    func configure(with viewModel: HoldingViewModel) {
        symbolLabel.text = viewModel.symbol
        quantityLabel.text = "NET QTY: \(viewModel.quantity)"
        ltpLabel.text = "LTP: \(viewModel.formattedLTP)"
        pnlLabel.text = "P&L: \(viewModel.formattedPNL)"
        pnlLabel.textColor = viewModel.pnlColor
    }
}
