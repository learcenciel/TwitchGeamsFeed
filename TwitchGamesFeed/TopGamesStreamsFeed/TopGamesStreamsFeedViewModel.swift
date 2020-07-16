//
//  TopGamesStreamsFeedViewModel.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class TopGamesStreamsFeedViewModel {
    
    enum TopGamesStreamsFeedError {
        case parseError(String)
    }
    
    private let apiManager: TwitchAPI
    private let disposable = DisposeBag()
    
    init(apiManager: TwitchAPI) {
        self.apiManager = apiManager
    }
    
    let slideMenuItems: BehaviorRelay<[SlideMenuItemType]> = BehaviorRelay(value: [])
    let slideMenuItemTapped: PublishSubject<SlideMenuItemType> = PublishSubject()
    let topGames: BehaviorRelay<[GameResponse]> = BehaviorRelay(value: [])
    let gameTapped: PublishSubject<GameResponse> = PublishSubject()
    let error: PublishSubject<TopGamesStreamsFeedError> = PublishSubject()
    var isLoading: Bool = false
    
    func fetchGamesList() {
        apiManager.fetchTopGames { result in
            switch result {
            case .success(let twitchGames):
                self.topGames.accept(twitchGames.games)
                self.isLoading = false
            case .failure(let err):
                self.error.onNext(.parseError(err.localizedDescription))
            }
        }
    }
}
