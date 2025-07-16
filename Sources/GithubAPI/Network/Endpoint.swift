//
//  Endpoint.swift
//  GithubAPI
//
//  Created by Артем on 14.07.2025.
//
import Foundation

public protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

internal enum GitHubEndpoint: Endpoint {
    case searchRepositories(query: String, page: Int, perPage: Int)
    
    var path: String { "/search/repositories" }
    var queryItems: [URLQueryItem] {
        switch self {
            case let .searchRepositories(query, page, perPage):
                return [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "perPage", value: "\(perPage)")
                ]
        }
    }
}

internal extension Endpoint {
    var ulrRequest: URLRequest {
        var components = URLComponents(string: "https://api.github.com")!
        components.path = path
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}
