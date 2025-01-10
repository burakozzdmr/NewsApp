//
//  HomepageViewModel.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import Foundation

//MARK: - Protocols

protocol HomepageViewModelProtocol: AnyObject {
    func didReceiveData(_ data: [News])
}

//MARK: - HomepageViewModel

class HomepageViewModel {
    weak var delegate: HomepageViewModelProtocol?
    var networkData: [News] = []
    var filteredData: [News] = []
    
    init() {
        NetworkManager.shared.getData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.networkData = data.articles ?? []
                delegate?.didReceiveData(networkData)
            case .failure(let error):
                print("View Model Error: \(error.localizedDescription)")
            }
            
        }
    }
}
