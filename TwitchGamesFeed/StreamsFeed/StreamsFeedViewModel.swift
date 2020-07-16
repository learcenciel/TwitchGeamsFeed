//
//  TwitchStreamsFeedViewModel.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 10.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum StreamType {
    case featured
    case gameCategory(String)
}

enum FeaturedStreamsFeedError {
    case parseError(String)
}

class StreamsFeedViewModel {
    
    var streamType: StreamType = .featured
    private let apiManager: TwitchAPI
    private let twitchStreamsFeedModelConverter: TwitchStreamsFeedModelConverter
    
    init(apiManager: TwitchAPI,
         twitchStreamsFeedModelConverter: TwitchStreamsFeedModelConverter) {
        self.apiManager = apiManager
        self.twitchStreamsFeedModelConverter = twitchStreamsFeedModelConverter
    }
    
    let featuredStreams: BehaviorRelay<[Stream]> = BehaviorRelay(value: [])
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<FeaturedStreamsFeedError> = PublishSubject()
    let featuredStreamTapped: PublishSubject<Stream> = PublishSubject()
    var isLoading: Bool = false
    let didFinish: PublishSubject<Void> = PublishSubject()
    var selectedGame: String = ""
    
    private let disposable = DisposeBag()
    
    func fetchStreamList() {
        self.loading.onNext(true)
        switch streamType {
        case .featured:
            apiManager.fetchFeaturedStreams(parameters: nil) { [weak self] result in
                self?.loading.onNext(false)
                switch result {
                case .success(let twitchFeaturedStreamResponse):
                    guard let convertedModel =
                        self?.twitchStreamsFeedModelConverter.convertTwitchFeaturedStreamResponse(twitchFeaturedStreamResponse)
                    else { return }
                    self?.featuredStreams.accept(convertedModel)
                    self?.isLoading = false
                case .failure(let httpError):
                    self?.error.onNext(.parseError(httpError.localizedDescription))
                }
            }
        case .gameCategory(let game):
            self.selectedGame = game
            apiManager.fetchStreams(parameters: ["query": self.selectedGame]) { [weak self] result in
                self?.loading.onNext(false)
                switch result {
                case .success(let twitchSearchGameStreamsResponse):
                    guard let convertedModel =
                        self?.twitchStreamsFeedModelConverter.convertTwitchSearchGameStreamResponse(twitchSearchGameStreamsResponse)
                    else { return }
                    self?.featuredStreams.accept(convertedModel)
                    self?.isLoading = false
                case .failure(let httpError):
                    self?.error.onNext(.parseError(httpError.localizedDescription))
                }
            }
        }
    }
    
    func fetchNextStreamsList(with offset: Int) {
        self.loading.onNext(true)
        switch streamType {
        case .featured:
            apiManager.fetchFeaturedStreams(parameters: ["offset": offset]) { [weak self] result in
                self?.loading.onNext(false)
                switch result {
                case .success(let twitchFeaturedStreamResponse):
                    guard
                        let convertedModel =
                        self?.twitchStreamsFeedModelConverter.convertTwitchFeaturedStreamResponse(twitchFeaturedStreamResponse),
                        let previousValue = self?.featuredStreams.value
                    else { return }
                    self?.featuredStreams.accept(previousValue + convertedModel)
                    self?.isLoading = false
                case .failure(let httpError):
                    self?.error.onNext(.parseError(httpError.localizedDescription))
                }
            }
        case .gameCategory:
            apiManager.fetchStreams(parameters: ["query": self.selectedGame,
                                                 "offset": offset]) { [weak self] result in
                self?.loading.onNext(false)
                switch result {
                case .success(let twitchSearchGameStreamsResponse):
                    guard let convertedModel =
                        self?.twitchStreamsFeedModelConverter.convertTwitchSearchGameStreamResponse(twitchSearchGameStreamsResponse),
                    let previousValue = self?.featuredStreams.value
                    else { return }
                    self?.featuredStreams.accept(previousValue + convertedModel)
                    self?.isLoading = false
                case .failure(let httpError):
                    self?.error.onNext(.parseError(httpError.localizedDescription))
                }
            }
        }
    }
}
