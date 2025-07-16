import Foundation
import Combine
@testable import GithubAPI
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//struct FakeRepository: Repository {
//    func searchRepos(query: String, page: Int, perPage: Int) -> AnyPublisher<[RepositoryModel], any Error> {
//        let sample = RepositoryModel(id: 1, name: "Name", full_name: "Full name", isPrivate: false, owner: OwnerModel(id: 123, login: "Login", avatar_url: "avatar", url: "url", type: "Organization"), html_url: "Html url", description: "description", fork: false, created_at: "Yesterday", updated_at: "Today", stargazers_count: 123, language: "English")
//        
//        return Just([sample])
//            .delay(for: .seconds(1), scheduler: RunLoop.main)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
//}

//let vm = SearchViewModel(repository: FakeRepository())

var cancellables = Set<AnyCancellable>()
let viewModel = SearchViewModel(repository: ServiceLocator.shared.repository)

viewModel.reposPublisher
    .sink { repos in
        let names = repos.map { $0.name }
        print(names)
    }
    .store(in: &cancellables)

viewModel.search(query: "Swift")

