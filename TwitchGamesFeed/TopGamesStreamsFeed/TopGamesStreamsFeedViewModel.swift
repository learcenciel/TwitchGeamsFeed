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
    
    private let apiManager: TwitchAPI
    
    init(apiManager: TwitchAPI) {
        self.apiManager = apiManager
    }
    
    enum TopGamesStreamsFeedError {
        case parseError(String)
    }
    
    let slideMenuItems: BehaviorRelay<[SlideMenuItemType]> = BehaviorRelay(value: [])
    let topGames: BehaviorRelay<[TwitchGameResponse]> = BehaviorRelay(value: [])
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<TopGamesStreamsFeedError> = PublishSubject()
    let gameTapped: PublishSubject<TwitchGame> = PublishSubject()
    let featuredStreamsItemMenuTapped: PublishSubject<SlideMenuItemType> = PublishSubject()
    var isLoading: Bool = false
    
    private let disposable = DisposeBag()
    
    func fetchGamesList() {
        self.loading.onNext(true)
        apiManager.fetchTopGames { result in
            self.loading.onNext(false)
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
