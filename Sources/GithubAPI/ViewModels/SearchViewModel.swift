//
//  SearchViewModel.swift
//  GithubAPI
//
//  Created by Артем on 15.07.2025.
//
import Foundation
import Combine

public protocol SearchViewModelProtocol {
    func search(query: String)
}

public final class SearchViewModel: ObservableObject, SearchViewModelProtocol {
    @Published public private(set) var repos: [RepositoryModel] = []
    public var reposPublisher: Published<[RepositoryModel]>.Publisher { $repos }
    
    private var repository: Repository
    private var cancellables = Set<AnyCancellable>()
    
    public init(repository: Repository) {
        self.repository = repository
    }
    
    public func search(query: String) {
        repository.searchRepos(query: query, page: 1, perPage: 20)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            print("Success")
                        case .failure(let error):
                            print("Error in API call:")
                            print(error)
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self else { return }
                    self.repos = value
                }
            )
            .store(in: &cancellables)
    }
}
