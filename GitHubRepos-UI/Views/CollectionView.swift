//
//  CollectionView.swift
//  GitHubRepos-UI
//
//  Created by Артем on 29.07.2025.
//
import UIKit
import GithubAPI
import Combine

class ListViewWithHeader: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var viewModel: SearchViewModelProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private var items: [RepositoryModel] = []
    
    private let searchBar = UISearchBar()
    private var debounceTimer: Timer?
    
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
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCellView.self, forCellReuseIdentifier: "Cell")
        
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        
        getRepos()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(items.isEmpty, indexPath)
        if items.isEmpty {
            let dummyCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var dummyCellConfig = UIListContentConfiguration.cell()
            dummyCellConfig.text = "No items"
            dummyCell.contentConfiguration = dummyCellConfig
            return dummyCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCellView else {
                return UITableViewCell()
            }
            cell.configure(with: items[indexPath.row])
            return cell
        }
    }
}

extension ListViewWithHeader: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            if searchText.isEmpty {
                self.items = []
                self.tableView.reloadData()
            } else {
                self.viewModel.search(query: searchText)
            }
        }
    }
}

// API Request
extension ListViewWithHeader {
    private func getRepos() {
        viewModel.reposPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] repos in
                guard let self else { return }
                self.items = repos
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}
