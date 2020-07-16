//
//  TwitchSearchFeedDIPart.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 12.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity

class SearchFeedDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { SearchFeedViewController() }
            .lifetime(.prototype)
        
        container.register(SearchFeedViewModel.init)
            .lifetime(.prototype)
        
        container.register(StreamSearchController.init)
            .as(SearchCapable.self)
            .lifetime(.prototype)
        
        container.register(ChannelSearchController.init)
            .as(SearchCapable.self)
            .lifetime(.prototype)
    }
}
