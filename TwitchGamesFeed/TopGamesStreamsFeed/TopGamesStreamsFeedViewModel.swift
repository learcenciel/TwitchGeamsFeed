//
//  TopGamesStreamsFeedViewModel.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift

class TopGamesStreamsFeedViewModel {
    
    private let apiManager = TwitchAPI(httpClient: HTTPClient())
    
    enum TopGamesStreamsFeedError {
        case parseError(String)
    }
    
    let topGames: PublishSubject<[TwitchGame]> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<TopGamesStreamsFeedError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    func fetchGamesList() {
        self.loading.onNext(true)
        apiManager.fetchTopGames(parameters: nil) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let twitchGames):
                self.topGames.onNext(twitchGames.data)
            case .failure(let err):
                self.error.onNext(.parseError(err.localizedDescription))
            }
        }
    }
}
