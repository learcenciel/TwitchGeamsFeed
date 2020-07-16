//
//  TwitchFeaturedStream.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct FeaturedStreamsResponse: Decodable {
    let data: [FeaturedStreams]
    
    private enum CodingKeys: String, CodingKey {
        case data = "featured"
    }
}

struct FeaturedStreams: Decodable {
    let stream: FeaturedStream
    
    private enum CodingKeys: String, CodingKey {
        case stream = "stream"
    }
}

struct FeaturedStream: Decodable {
    let viewers: Int
    let channel: GameSearchChannel
    let imageBoxInfo: ImageBox

    
    private enum CodingKeys: String, CodingKey {
        case viewers = "viewers"
        case imageBoxInfo = "preview"
        case channel = "channel"
    }
}
