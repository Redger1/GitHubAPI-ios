//
//  DiffableTableView.swift
//  GitHubRepos-UI
//
//  Created by Артем on 30.07.2025.
//
import UIKit
import GithubAPI
import Combine

private enum Section {
    case main
}

class DiffableTableView: UIViewController {
    var viewModel: SearchViewModelProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var repos: [RepositoryModel] = []
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, RepositoryModel> = {
        let ds = UITableViewDiffableDataSource<Section, RepositoryModel>(
            tableView: tableView, cellProvider: { tableView, indexPath, repo in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = repo.name
                content.secondaryText = repo.description
                cell.contentConfiguration = content
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        )
        return ds
    }()
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        configureSearchController()
        configureTableView()
        
        getRepos()
    }
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "Search repositories..."
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func getRepos() {
        viewModel.reposPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] repos in
                guard let self else { return }
                self.repos = repos
            }
            .store(in: &cancellables)
    }
}

extension DiffableTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        viewModel.search(query: text)
    }
}

extension RepositoryModel: @unchecked @retroactive Sendable {}
