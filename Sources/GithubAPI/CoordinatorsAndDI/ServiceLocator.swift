//
//  ServiceLocator.swift
//  GithubAPI
//
//  Created by Артем on 15.07.2025.
//
import Foundation

public protocol Cooridnator {
    func start()
}

@MainActor
public final class ServiceLocator {
    public static let shared = ServiceLocator()
    private init() {}
    
    public lazy var apiClient: APIClient = NetworkService()
    public lazy var repository: Repository = GithubRepository(client: apiClient)
    
    public func makeSearchViewModel() -> SearchViewModelProtocol {
        SearchViewModel(repository: repository)
    }
}
