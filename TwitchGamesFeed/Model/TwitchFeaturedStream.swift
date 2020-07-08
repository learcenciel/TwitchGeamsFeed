//
//  TwitchFeaturedStream.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct TwitchFeaturedStream: Decodable {
    let data: [FeaturedResponse]
    let pagination: Pagination
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case pagination = "pagination"
    }
}

struct FeaturedResponse: Decodable {
    let userName: String
    let streamLanguage: String
    let streamTitle: String
    let viewerCount: Int
    let thumbnailUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case streamLanguage = "language"
        case streamTitle = "title"
        case viewerCount = "viewer_count"
        case thumbnailUrl = "thumbnail_url"
    }
}

