//
//  NewsModel.swift
//  NewsApp
//
//  Created by Burak Özdemir on 9.01.2025.
//

import Foundation

struct NewsModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [News]?
}
