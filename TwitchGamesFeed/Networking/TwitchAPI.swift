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
    
    func fetchTopGames(completionHandler: @escaping(Result<TwitchPopularGamesResponse, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/kraken/games/top",
                       headers: ["Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz",
                                 "Accept": "application/vnd.twitchtv.v5+json"],
                       parameters: nil,
                       completionHandler: completionHandler)
    }
    
    func fetchFeaturedStreams(parameters: [String: Any]?,
                              completionHandler: @escaping(Result<TwitchFeaturedStream, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/helix/streams",
                       headers: ["Authorization": "Bearer l7sadz3bg5ir8lepdetca7h5tq7apv",
                                 "Client-ID": "m61dz6t4k3mkbn7tllby7j7hhob7uz"],
                       parameters: parameters,
                       completionHandler: completionHandler)
    }
}
