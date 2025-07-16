//
//  NetworkService.swift
//  GithubAPI
//
//  Created by Артем on 14.07.2025.
//
import Combine
import Foundation

public protocol APIClient {
    func request<T: Decodable>(_ type: T.Type, endpoint: Endpoint) -> AnyPublisher<T, Error>
}

// MARK: Добавить обработку ошибок
internal final class NetworkService: APIClient {
    func request<T: Decodable>(_ type: T.Type, endpoint: Endpoint) -> AnyPublisher<T, any Error> {
        URLSession.shared.dataTaskPublisher(for: endpoint.ulrRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
