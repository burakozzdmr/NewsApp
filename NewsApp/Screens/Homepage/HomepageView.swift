//
//  HomepageView.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import UIKit
import SnapKit

//MARK: - Protocols

protocol DataTransferDelegate: AnyObject {
    func didSubmitData(data: News)
}

//MARK: - HomepageView

class HomepageView: UIViewController {

    //MARK: - Properties

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Type a text"
        searchBar.keyboardType = .default
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .default
        return searchBar
    }()
    
    private let newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = true
        tableView.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        return tableView
    }()
    
    var tableViewData: [News] = []
    var viewModel: HomepageViewModel = .init()
    weak var dataDelegate: DataTransferDelegate?
    
    //MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        searchBar.delegate = self
        viewModel.delegate = self
        
        configureUI()
    }
    
    //MARK: - Private Methods

    private func addViews() {
        view.addSubview(searchBar)
        view.addSubview(newsTableView)
    }
    
    private func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        newsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureUI() {
        navigationItem.title = "Appcent News App"
        addViews()
        configureConstraints()
    }
}

//MARK: - UITableViewDataSource

extension HomepageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = tableViewData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.configure(with: news)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension HomepageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetail = NewsDetailView()
        let selectedNews = tableViewData[indexPath.row]
        
        self.dataDelegate = newsDetail
        
        self.navigationController?.pushViewController(newsDetail, animated: true)
        dataDelegate?.didSubmitData(data: selectedNews)
    }
}

//MARK: - UISearchBarDelegate

extension HomepageView: UISearchBarDelegate {       
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        } else {
            viewModel.searchNews(for: searchText) { searchArray in
                DispatchQueue.main.async {
                    self.tableViewData = searchArray
                    self.newsTableView.reloadData()
                }
            }
        }
    }
}

//MARK: - HomepageViewModelProtocol

extension HomepageView: HomepageViewModelProtocol {
    func didReceiveData(_ data: [News]) {
        self.tableViewData = data
        DispatchQueue.main.async {
            self.newsTableView.reloadData()
        }
    }
}
