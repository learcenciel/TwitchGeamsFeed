//
//  AppFramework.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity

public class AppFramework: DIFramework {
    public static func load(container: DIContainer) {
        container.append(part: CoordinatorDIPart.self)
        container.append(part: TopGamesStreamsFeedDIPart.self)
        container.append(part: TwitchStreamsFeedDIPart.self)
        container.append(part: SearchFeedDIPart.self)
        container.append(part: FavoriteGamesFeedDIPart.self)
        container.append(part: PersistanceDIPart.self)
    }
}
