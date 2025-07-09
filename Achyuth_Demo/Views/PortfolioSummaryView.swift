//
//  PortfolioSummaryView.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit

class PortfolioSummaryView: UIView {
    private let stackView = UIStackView()
    private let currentValueLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let todaysPNLLabel = UILabel()
    private let totalPNLLabel = UILabel()
    
    private let currentValueTitleLabel = UILabel()
    private let totalInvestmentTitleLabel = UILabel()
    private let todaysPNLTitleLabel = UILabel()
    private let totalPNLTitleLabel = UILabel()
    
    private var isExpanded = false
    private let expandButton = UIButton(type: .system)
    private let collapsibleStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        let currentValueContainer = createSummaryRow(titleLabel: currentValueTitleLabel, valueLabel: currentValueLabel)
        stackView.addArrangedSubview(currentValueContainer)
        
        // Collapsible content
        collapsibleStackView.axis = .vertical
        collapsibleStackView.spacing = 16
        collapsibleStackView.isHidden = !isExpanded
        
        let totalInvestmentContainer = createSummaryRow(titleLabel: totalInvestmentTitleLabel, valueLabel: totalInvestmentLabel)
        let todaysPNLContainer = createSummaryRow(titleLabel: todaysPNLTitleLabel, valueLabel: todaysPNLLabel)
        let totalPNLContainer = createSummaryRow(titleLabel: totalPNLTitleLabel, valueLabel: totalPNLLabel)
        
        collapsibleStackView.addArrangedSubview(totalInvestmentContainer)
        collapsibleStackView.addArrangedSubview(todaysPNLContainer)
        collapsibleStackView.addArrangedSubview(totalPNLContainer)
        
        stackView.addArrangedSubview(collapsibleStackView)
        
        // Expand/Collapse button
        expandButton.setTitle("▼", for: .normal)
        expandButton.addTarget(self, action: #selector(toggleExpanded), for: .touchUpInside)
        addSubview(expandButton)
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        configureTitleLabels()
        configureValueLabels()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            expandButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            expandButton.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
    }
    
    private func createSummaryRow(titleLabel: UILabel, valueLabel: UILabel) -> UIView {
        let container = UIView()
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16)
        ])
        
        return container
    }
    
    private func configureTitleLabels() {
        currentValueTitleLabel.text = "Current value*"
        totalInvestmentTitleLabel.text = "Total investment*"
        todaysPNLTitleLabel.text = "Today's Profit & Loss*"
        totalPNLTitleLabel.text = "Profit & Loss*"
        
        [currentValueTitleLabel, totalInvestmentTitleLabel, todaysPNLTitleLabel, totalPNLTitleLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .label
        }
    }
    
    private func configureValueLabels() {
        [currentValueLabel, totalInvestmentLabel, todaysPNLLabel, totalPNLLabel].forEach {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textAlignment = .left
        }
    }
    
    @objc private func toggleExpanded() {
        isExpanded.toggle()
        
        Task { @MainActor in
            UIView.animate(withDuration: 0.3) {
                self.collapsibleStackView.isHidden = !self.isExpanded
                self.expandButton.setTitle(self.isExpanded ? "▲" : "▼", for: .normal)
            }
        }
    }
    
    func configure(with summary: PortfolioSummary) {
        currentValueLabel.text = "₹\(String(format: "%.2f", summary.currentValue))"
        totalInvestmentLabel.text = "₹\(String(format: "%.2f", summary.totalInvestment))"
        
        let todaysPNLText = summary.todaysPNL >= 0 ? "₹\(String(format: "%.2f", summary.todaysPNL))" : "-₹\(String(format: "%.2f", abs(summary.todaysPNL)))"
        todaysPNLLabel.text = todaysPNLText
        todaysPNLLabel.textColor = summary.todaysPNL >= 0 ? .systemGreen : .systemRed
        
        let totalPNLText = summary.totalPNL >= 0 ? "₹\(String(format: "%.2f", summary.totalPNL))" : "-₹\(String(format: "%.2f", abs(summary.totalPNL)))"
        let percentageText = String(format: "%.2f", abs(summary.totalPNLPercentage))
        totalPNLLabel.text = "\(totalPNLText) (\(percentageText)%)"
        totalPNLLabel.textColor = summary.totalPNL >= 0 ? .systemGreen : .systemRed
    }
}
