//
//  news.swift
//  NASANews
//
//  Created by Haneen Medhat on 15/10/2024.
//

import Foundation

struct NewsInfo: Codable,Equatable {
    let author: String?
    let title: String?
    let description: String?
    let image: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description = "desription" 
        case image = "imageUrl"
        case date = "publishedAt"
    }
    
}


