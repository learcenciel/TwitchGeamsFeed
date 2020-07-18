//
//  TwitchGame.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct PopularGamesResponse: Decodable {
    var games: [GameResponse]
    
    private enum CodingKeys: String, CodingKey {
        case games = "top"
    }
}

struct GameResponse: Decodable {
    let game: Game
    let viewersCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case game = "game"
        case viewersCount = "viewers"
    }
}

struct Game: Decodable {
    let name: String
    let id: Int
    let imageBox: ImageBox
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "_id"
        case imageBox = "box"
    }
}

struct ImageBox: Decodable {
    let gameUrlPath: String
    
    private enum CodingKeys: String, CodingKey {
        case gameUrlPath = "template"
    }
}
