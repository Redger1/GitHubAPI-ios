//
//  CustomCellView.swift
//  GitHubRepos-UI
//
//  Created by Артем on 29.07.2025.
//
import UIKit
import GithubAPI

class CustomCellView: UITableViewCell {
    // Автор репозитория
    private let authorImage = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 20),
            image.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        image.layer.cornerRadius = 10
        return image
    }()
    private let authorName = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorRow: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [authorImage, authorName])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // Название и описание
    private let nameLabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Звезды репозитория
    private let starsCountLabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var starsRow: UIStackView = {
        let starImage = UIImageView(image: UIImage(systemName: "star"))
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.tintColor = .systemGray
        NSLayoutConstraint.activate([
            starImage.widthAnchor.constraint(equalToConstant: 15),
            starImage.heightAnchor.constraint(equalToConstant: 15),
        ])
        
        let sv = UIStackView(arrangedSubviews: [starImage, starsCountLabel, languageLabel])
        sv.axis = .horizontal
        sv.alignment = .leading
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // Язык, на котором написан репозиторий
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Layout ячейки
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [authorRow, nameLabel, descriptionLabel, starsRow])
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    func configure(with data: RepositoryModel) {
        nameLabel.text = data.name
        descriptionLabel.text = data.description
        starsCountLabel.text = data.stargazers_count?.description ?? ""
        authorName.text = data.owner?.login ?? ""
        languageLabel.text = data.language ?? ""
        
        guard let owner = data.owner else { return }
        if let url = URL(string: owner.avatar_url) {
            authorImage.load(from: url)
        }
    }
}


