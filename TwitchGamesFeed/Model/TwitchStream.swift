//
//  TwitchStream.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 10.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

struct TwitchStream: Decodable {
    var twitchStreamInfo: [TwitchStreamInfo]
    let nextUrl: String
}

struct TwitchStreamInfo: Decodable {
    let title: String
    let userName: String
    let viewerCount: Int
    let language: String
    let thumbnailUrl: String
}
