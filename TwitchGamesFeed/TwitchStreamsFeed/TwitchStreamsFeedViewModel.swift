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

class TwitchStreamsFeedViewModel {
    
    enum StreamType {
        case featured
        case gameCategory
    }
    
    var streamType: StreamType = .featured
    private let apiManager: TwitchAPI
    private let twitchStreamsFeedModelConverter: TwitchStreamsFeedModelConverter
    
    init(apiManager: TwitchAPI,
         twitchStreamsFeedModelConverter: TwitchStreamsFeedModelConverter) {
        self.apiManager = apiManager
        self.twitchStreamsFeedModelConverter = twitchStreamsFeedModelConverter
    }
    
    enum FeaturedStreamsFeedError {
        case parseError(String)
    }
    
    let featuredStreams: BehaviorRelay<[TwitchStreamInfo]> = BehaviorRelay(value: [])
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<FeaturedStreamsFeedError> = PublishSubject()
    let featuredStreamTapped: PublishSubject<TwitchStreamInfo> = PublishSubject()
    var isLoading: Bool = false
    var nextUrl: String = ""
    let didFinish: PublishSubject<Void> = PublishSubject()
    
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
                    self?.featuredStreams.accept(convertedModel.twitchStreamInfo)
                    self?.nextUrl = convertedModel.nextUrl
                    self?.isLoading = false
                case .failure(let httpError):
                    self?.error.onNext(.parseError(httpError.localizedDescription))
                }
            }
        case .gameCategory:
            break
        }
    }
    
    func fetchNextGamesList() {
        self.loading.onNext(true)
        switch streamType {
        case .featured:
            apiManager.fetchFeaturedStreams(parameters: ["after": self.nextUrl]) { [weak self] result in
                self?.loading.onNext(false)
                switch result {
                case .success(let twitchFeaturedStreamResponse):
                    guard
                        let convertedModel =
                        self?.twitchStreamsFeedModelConverter.convertTwitchFeaturedStreamResponse(twitchFeaturedStreamResponse),
                        let previousValue = self?.featuredStreams.value
                    else { return }
                    self?.featuredStreams.accept(previousValue + convertedModel.twitchStreamInfo)
                    self?.isLoading = false
                case .failure(let httpError):
                    self?.error.onNext(.parseError(httpError.localizedDescription))
                }
            }
        case .gameCategory:
            break
        }
    }
}
