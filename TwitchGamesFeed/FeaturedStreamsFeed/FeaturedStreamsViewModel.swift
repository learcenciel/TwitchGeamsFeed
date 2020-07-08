//
//  FeaturedStreamsViewModel.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class FeaturedStreamsViewModel {
    
    private let apiManager = TwitchAPI(httpClient: HTTPClient())
    
    enum FeaturedStreamsFeedError {
        case parseError(String)
    }
    
    let featuredStreams: BehaviorRelay<[FeaturedResponse]> = BehaviorRelay(value: [])
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<FeaturedStreamsFeedError> = PublishSubject()
    let featuredStreamTapped: PublishSubject<FeaturedResponse> = PublishSubject()
    var isLoading: Bool = false
    var nextUrl: String = ""
    let didFinish: PublishSubject<Void> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    func fetchFeaturedStreamsList() {
        self.loading.onNext(true)
        apiManager.fetchFeaturedStreams(parameters: nil) { [unowned self] result in
            self.loading.onNext(false)
            switch result {
            case .success(let featuredStreams):
                self.featuredStreams.accept(featuredStreams.data)
                self.nextUrl = featuredStreams.pagination.cursor
                self.isLoading = false
            case .failure(let err):
                self.error.onNext(.parseError(err.localizedDescription))
            }
        }
    }
    
    deinit {
        print("DEINIT VIEWMODEL")
    }

    func fetchNextGamesList() {
        self.loading.onNext(true)
        apiManager.fetchFeaturedStreams(parameters: ["after": self.nextUrl]) { [unowned self] result in
            self.loading.onNext(false)
            switch result {
            case .success(let featuredStreams):
                self.featuredStreams.accept(self.featuredStreams.value + featuredStreams.data)
                self.nextUrl = featuredStreams.pagination.cursor
                self.isLoading = false
            case .failure(let err):
                self.error.onNext(.parseError(err.localizedDescription))
            }
        }
    }
}
