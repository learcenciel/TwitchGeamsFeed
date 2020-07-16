//
//  FavoriteGamesFeedViewModel.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class FavoriteGamesFeedViewModel {
    
    private let apiManager: TwitchAPI
    private let databaseManager: DatabaseManager
    
    init(apiManager: TwitchAPI,
         databaseManager: DatabaseManager) {
        self.apiManager = apiManager
        self.databaseManager = databaseManager
    }
    
    enum TopGamesStreamsFeedError {
        case parseError(String)
    }
    
    let slideMenuItems: BehaviorRelay<[SlideMenuItemType]> = BehaviorRelay(value: [])
    let featuredStreamsItemMenuTapped: PublishSubject<SlideMenuItemType> = PublishSubject()
    let topGames: PublishSubject<[GameResponse]> = PublishSubject()
    let gameTapped: PublishSubject<GameResponse> = PublishSubject()
        
    func fetchGamesList() {
        self.topGames.onNext(RealmGame.getGameResponse(databaseManager.getGames()))
    }
}
