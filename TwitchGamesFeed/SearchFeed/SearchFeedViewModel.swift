//
//  TwitchSearchFeedViewModel.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 12.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SearchFeedViewModel {
    let searchStreamTapped: PublishSubject<Stream> = PublishSubject()
    let searchChannelTapped: PublishSubject<SearchChannel> = PublishSubject()
}
