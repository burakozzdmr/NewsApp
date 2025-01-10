//
//  NewsDetailViewModel.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import Foundation

class NewsDetailViewModel {
    func addFavouriteNews(data: News?) {
        guard let arrivedData = data else { return }

        var favourites = UserDefaults.standard.array(forKey: "favouriteNews") as? [[String: String]] ?? []

        let newsData: [String: String] = [
            "title": arrivedData.title ?? "",
            "author": arrivedData.author ?? "",
            "publishedAt": arrivedData.publishedAt ?? "",
            "description": arrivedData.description ?? "",
            "urlToImage": arrivedData.urlToImage ?? "",
            "url": arrivedData.url ?? ""
        ]

        favourites.append(newsData)
        UserDefaults.standard.set(favourites, forKey: "favouriteNews")
    }
}
