//
//  TwitchSearchGameStream.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 12.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct SearchGameStreams: Decodable {
    let data: [TwitchGameSearchResponse]
    
    private enum CodingKeys: String, CodingKey {
        case data = "streams"
    }
}

struct TwitchGameSearchResponse: Decodable {
    let channel: GameSearchChannel
    let viewerCount: Int
    let imageBoxInfo: ImageBox
    
    private enum CodingKeys: String, CodingKey {
        case channel = "channel"
        case viewerCount = "viewers"
        case imageBoxInfo = "preview"
    }
}

struct GameSearchChannel: Decodable {
    let name: String
    let title: String
    let language: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "display_name"
        case title = "status"
        case language = "broadcaster_language"
    }
}
