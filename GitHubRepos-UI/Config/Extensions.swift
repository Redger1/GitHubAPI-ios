//
//  Extensions.swift
//  GitHubRepos-UI
//
//  Created by Артем on 29.07.2025.
//
import Foundation
import UIKit

extension UIImageView {
    func load(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let data = data,
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
