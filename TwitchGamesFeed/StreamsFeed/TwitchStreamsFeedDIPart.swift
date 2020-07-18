//
//  TwitchStreamsFeedDIPart.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 10.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity

class TwitchStreamsFeedDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { StreamsFeedViewController() }
            .lifetime(.prototype)
        
        container.register(StreamsFeedViewModel.init)
            .lifetime(.prototype)
        
        container.register(TwitchStreamsFeedModelConverter.init)
            .lifetime(.objectGraph)
    }
}
