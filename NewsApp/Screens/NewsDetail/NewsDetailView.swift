//  NewsDetailView.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import UIKit
import SnapKit

//MARK: - NewsDetailView

class NewsDetailView: UIViewController {
    
//MARK: - Properties
    
    private let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let goToNewsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Habere Git", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(goToNewsPressed), for: .touchUpInside)
        return button
    }()
    
    var arrivedData: News?
    var viewModel = NewsDetailViewModel()
    
//MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
    }
    
//MARK: - Private Methods
    
    private func configureUI() {
        setupNavigationBarButtons()
        addViews()
        configureConstraints()
        prepareUI()
    }
    
    private func prepareUI() {
        guard let arrivedData = arrivedData else { return }
        
        titleLabel.text = arrivedData.title
        authorLabel.text = arrivedData.author
        dateLabel.text = arrivedData.publishedAt
        descriptionLabel.text = arrivedData.description
        
        if let safeURL = arrivedData.urlToImage, let connectionURL = URL(string: safeURL) {
            detailImageView.kf.setImage(with: connectionURL)
        }
    }
    
    private func addViews() {
        view.addSubview(detailImageView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(goToNewsButton)
    }
    
    private func setupNavigationBarButtons() {
        let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favouriteButtonTapped))
        favouriteButton.tintColor = .red
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        shareButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [favouriteButton, shareButton]
    }
    
    private func configureConstraints() {
        detailImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        goToNewsButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
//MARK: - Objective-C Methods
    
    @objc private func favouriteButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.addFavouriteNews(data: arrivedData)
    }
    
    @objc private func shareButtonTapped(_ sender: UIBarButtonItem) {
        guard let arrivedData = arrivedData else { return }

        let text = arrivedData.title ?? ""
        let url = URL(string: arrivedData.url ?? "")!
        let itemsToShare: [Any] = [text, url]

        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }

        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func goToNewsPressed() {
        guard let url = URL(string: arrivedData?.url ?? "") else { return }
        UIApplication.shared.open(url)
    }
}

//MARK: - DataTransferDelegate

extension NewsDetailView: DataTransferDelegate {
    func didSubmitData(data: News) {
        self.arrivedData = data
    }
}
