//
//  FeaturedStreamsDIPart.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity

class FeaturedStreamsDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register(FeaturedStreamsViewController.init)
            .lifetime(.prototype)
        
        container.register(FeaturedStreamsViewModel.init)
            .lifetime(.prototype)
    }
}
