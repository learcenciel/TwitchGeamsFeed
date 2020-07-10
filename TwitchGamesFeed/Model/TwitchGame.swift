//
//  TwitchGame.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct TwitchPopularGamesResponse: Decodable {
    let games: [TwitchGameResponse]
    
    private enum CodingKeys: String, CodingKey {
        case games = "top"
    }
}

struct TwitchGameResponse: Decodable {
    let game: TwitchGame
    let viewersCount: Int
    let channelsCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case game = "game"
        case viewersCount = "viewers"
        case channelsCount = "channels"
    }
}

struct TwitchGame: Decodable {
    let name: String
    let imageBox: ImageBox
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case imageBox = "box"
    }
}

struct ImageBox: Decodable {
    let gameUrlPath: String
    
    private enum CodingKeys: String, CodingKey {
        case gameUrlPath = "template"
    }
}
