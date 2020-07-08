//
//  TopGamesStreamsFeedViewModel.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class TopGamesStreamsFeedViewModel {
    
    private let apiManager = TwitchAPI(httpClient: HTTPClient())
    
    enum TopGamesStreamsFeedError {
        case parseError(String)
    }
    
    let slideMenuItems: BehaviorRelay<[SlideMenuItemType]> = BehaviorRelay(value: [])
    let topGames: BehaviorRelay<[TwitchGame]> = BehaviorRelay(value: [])
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<TopGamesStreamsFeedError> = PublishSubject()
    let gameTapped: PublishSubject<TwitchGame> = PublishSubject()
    let featuredStreamsItemMenuTapped: PublishSubject<SlideMenuItemType> = PublishSubject()
    var isLoading: Bool = false
    var nextUrl: String = ""
    
    private let disposable = DisposeBag()
    
    func fetchGamesList() {
        self.loading.onNext(true)
        apiManager.fetchTopGames(parameters: nil) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let twitchGames):
                self.topGames.accept(twitchGames.data)
                self.nextUrl = twitchGames.pagination.cursor
                self.isLoading = false
            case .failure(let err):
                self.error.onNext(.parseError(err.localizedDescription))
            }
        }
    }
    
    func fetchNextGamesList() {
        self.loading.onNext(true)
        apiManager.fetchTopGames(parameters: ["after": self.nextUrl]) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let twitchGames):
                self.topGames.accept(self.topGames.value + twitchGames.data)
                self.nextUrl = twitchGames.pagination.cursor
                self.isLoading = false
            case .failure(let err):
                self.error.onNext(.parseError(err.localizedDescription))
            }
        }
    }
}
