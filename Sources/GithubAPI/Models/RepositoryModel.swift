//
//  RepositoryModel.swift
//  GithubAPI
//
//  Created by Артем on 14.07.2025.
//
import Foundation

public struct RepositoryModel: Identifiable, Hashable, Decodable {
    public let id: Int
    public let name: String
    public let full_name: String
    public let isPrivate: Bool
    public let owner: OwnerModel
    public let html_url: String
    public let description: String
    public let fork: Bool
    public let created_at: String
    public let updated_at: String
    public let stargazers_count: Int
    public let language: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, full_name, owner, html_url, description, fork, created_at, updated_at, stargazers_count, language
        case isPrivate = "private"
    }
}

