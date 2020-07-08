//
//  TopGamesStreamsFeedDIPart.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity

class TopGamesStreamsFeedDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register(TopGamesStreamsFeedViewController.init)
            .lifetime(.prototype)
        
        container.register(TopGamesStreamsFeedViewModel.init)
            .lifetime(.prototype)
        
        container.register(TwitchAPI.init)
        container.register(HTTPClient.init)
    }
}
