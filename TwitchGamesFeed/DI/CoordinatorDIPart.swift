//
//  CoordinatorDIPart.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity
import UIKit

class CoordinatorDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register(AppCoordinator.init)
            .lifetime(.single)
        
        container.register(TopGamesFeedCoordinator.init)
            .lifetime(.prototype)
        
        container.register(StreamsFeedCoordinator.init)
            .lifetime(.prototype)
        
        container.register(SearchFeedCoordinator.init)
            .lifetime(.prototype)
        
        container.register(FavoriteGamesFeedCoordinator.init)
            .lifetime(.prototype)
    }
}
