//
//  NewsDetailView.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import UIKit

class NewsDetailView: UIViewController {

    var homepage: HomepageView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homepage.delegate = self
    }


}

extension NewsDetailView: DataTransferDelegate {
    func didSubmitData(data: News) {
        print("didSubmitData çalıştı.")
    }
}
