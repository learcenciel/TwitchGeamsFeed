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
        container.register(TwitchStreamsFeedViewController.init)
            .lifetime(.prototype)
        
        container.register(TwitchStreamsFeedViewModel.init)
            .lifetime(.prototype)
        
        container.register(TwitchStreamsFeedModelConverter.init)
            .lifetime(.objectGraph)
    }
}
