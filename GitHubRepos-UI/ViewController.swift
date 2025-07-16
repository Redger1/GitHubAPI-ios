//
//  ViewController.swift
//  GitHubRepos-UI
//
//  Created by Артем on 15.07.2025.
//

import UIKit
import GithubAPI
import Combine

class ViewController: UIViewController {
    private var viewModel: SearchViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
 
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    require init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label: UILabel {
        let newLabel = UILabel()
        newLabel.text = "Repos count:"
        return newLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(label)
        
        viewModel.search(query: "swift")
        
        viewModel.reposPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] repos in
                guard let self else { return }
                self.label.text = "Repos count: \(repos.count)"
            }
            .store(in: &cancellables)
    }
}

