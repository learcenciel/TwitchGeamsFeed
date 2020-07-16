//
//  TwitchSearchChannel.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 15.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct ChannelSearchResponse: Decodable {
    let data: [SearchChannel]
    
    private enum CodingKeys: String, CodingKey {
        case data = "channels"
    }
}

struct SearchChannel: Decodable {
    let name: String
    let isPartner: Bool
    let logoUrl: String
    let followersCount: Int
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "display_name"
        case isPartner = "partner"
        case logoUrl = "logo"
        case followersCount = "followers"
        case url = "url"
    }
}
