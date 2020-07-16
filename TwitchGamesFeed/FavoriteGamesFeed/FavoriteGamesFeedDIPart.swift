//
//  FavoriteGamesFeedDIPart.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity

class FavoriteGamesFeedDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { FavoriteGamesFeedViewController() }
            .lifetime(.prototype)
        
        container.register(FavoriteGamesFeedViewModel.init)
            .lifetime(.prototype)
    }
}
