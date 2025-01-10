//
//  NewsCell.swift
//  NewsApp
//
//  Created by Burak Özdemir on 10.01.2025.
//

import UIKit
import SnapKit
import Kingfisher

class NewsCell: UITableViewCell {

    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Initializer 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func configureUI() {
        addViews()
        configureConstraints()
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(newsImageView)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    //MARK: - Configure Method
    
    func configure(with cell: News) {
        titleLabel.text = cell.title
        descriptionLabel.text = cell.description
        newsImageView.kf.setImage(with: URL(string: cell.urlToImage ?? ""))
    }
}
