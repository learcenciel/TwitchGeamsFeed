//
//  TwitchAPI.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

class TwitchAPI {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchTopGames(completionHandler: @escaping(Result<PopularGamesResponse, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/kraken/games/top",
                       headers: ["Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz",
                                 "Accept": "application/vnd.twitchtv.v5+json"],
                       parameters: nil,
                       completionHandler: completionHandler)
    }
    
    func fetchFeaturedStreams(parameters: [String: Any]?,
                              completionHandler: @escaping(Result<FeaturedStreamsResponse, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/kraken/streams/featured",
                       headers: ["Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz",
                                 "Accept": "application/vnd.twitchtv.v5+json"],
                       parameters: parameters,
                       completionHandler: completionHandler)
    }
    
    func fetchChannels(parameters: [String: Any]?,
                              completionHandler: @escaping(Result<ChannelSearchResponse, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/kraken/search/channels?query=starcraft",
                       headers: ["Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz",
                                 "Accept": "application/vnd.twitchtv.v5+json"],
                       parameters: parameters,
                       completionHandler: completionHandler)
    }
    
    func fetchStreams(parameters: [String: Any]?,
                              completionHandler: @escaping(Result<SearchGameStreams, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/kraken/search/streams",
                       headers: ["Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz",
                                 "Accept": "application/vnd.twitchtv.v5+json"],
                       parameters: parameters,
                       completionHandler: completionHandler)
    }
}
