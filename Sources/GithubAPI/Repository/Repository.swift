//
//  Repository.swift
//  GithubAPI
//
//  Created by Артем on 15.07.2025.
//
import Foundation
import Combine

public protocol Repository {
    func searchRepos(query: String, page: Int, perPage: Int) -> AnyPublisher<[RepositoryModel], Error>
}

internal final class GithubRepository: Repository {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func searchRepos(query: String, page: Int = 1, perPage: Int = 20) -> AnyPublisher<[RepositoryModel], Error> {
        client.request(SearchResponse.self, endpoint: GitHubEndpoint.searchRepositories(query: query, page: page, perPage: perPage))
            .map { $0.items }
            .eraseToAnyPublisher()
    }
}

private struct SearchResponse: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [RepositoryModel]
}
