//
//  ViewController.swift
//  Achyuth_Demo
//
//  Created by G ACHYUTH KUMAR on 09/07/25.
//

import Foundation
import UIKit
import Combine
// MARK: - Main View Controller
@MainActor
class PortfolioViewController: UIViewController {
    private let tableView = UITableView()
    private let summaryView = PortfolioSummaryView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: any PortfolioViewModelProtocol
    private var dataTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    
    @MainActor
    init(viewModel: any PortfolioViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        self.viewModel = PortfolioViewModel() // or inject a mock/default
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeViewModel()
        loadData()
    }
    
    deinit {
        dataTask?.cancel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Portfolio"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Setup summary view
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        view.addSubview(tableView)
        view.addSubview(summaryView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor, constant: -16),
            
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func observeViewModel() {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    if !self.refreshControl.isRefreshing {
                        self.loadingIndicator.startAnimating()
                    }
                } else {
                    self.loadingIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.holdingsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.portfolioSummaryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] summary in
                if let summary = summary {
                    self?.summaryView.configure(with: summary)
                }
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if let message = message {
                    self?.showError(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func loadData() {
        dataTask?.cancel()
        dataTask = Task {
            await viewModel.loadPortfolioData()
        }
    }
    
    @objc private func refreshData() {
        loadData()
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension PortfolioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.identifier, for: indexPath) as! HoldingCell
        let holding = viewModel.holdings[indexPath.row]
        cell.configure(with: holding)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
