//
//  NewsDetailView.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import UIKit

class NewsDetailView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad çalıştı")
    }
}

extension NewsDetailView: DataTransferDelegate {
    func didSubmitData(data: News) {
        print("didSubmitData çalıştı.")
        print("Data: \(data)")
    }
}
