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

    func fetchTopGames(parameters: [String: Any]?,
                             completionHandler: @escaping(Result<TwitchResponse, HTTPErrors>) -> Void) {
        httpClient.get(url: "https://api.twitch.tv/helix/games/top",
                       parameters: parameters,
                       completionHandler: completionHandler)
    }
}
