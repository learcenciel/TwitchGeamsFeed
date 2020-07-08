//
//  TwitchGame.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct TwitchResponse: Decodable {
    let data: [TwitchGame]
    let pagination: Pagination
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case pagination = "pagination"
    }
}

struct TwitchGame: Decodable {
    let id: String
    let name: String
    let posterPathUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case posterPathUrl = "box_art_url"
    }
}

struct Pagination: Decodable {
    let cursor: String
    
    private enum CodingKeys: String, CodingKey {
        case cursor = "cursor"
    }
}
