//
//  OwnerModel.swift
//  GithubAPI
//
//  Created by Артем on 14.07.2025.
//
import Foundation

public struct OwnerModel: Identifiable, Hashable, Decodable {
    public let id: Int
    public let login: String
    public let avatar_url: String
    public let url: String
    public let type: String
}
