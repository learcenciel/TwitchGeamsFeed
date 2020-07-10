//
//  TwitchStreamsFeedModelConverter.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 10.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import UIKit

class TwitchStreamsFeedModelConverter {
    func convertTwitchFeaturedStreamResponse(_ twitchFeaturedStreamResponse: TwitchFeaturedStream) -> TwitchStream {
        
        var twitchStream = TwitchStream(twitchStreamInfo: [], nextUrl: twitchFeaturedStreamResponse.pagination.cursor)
        
        for stream in twitchFeaturedStreamResponse.data {
            twitchStream.twitchStreamInfo.append(TwitchStreamInfo(title: stream.streamTitle,
                                                                  userName: stream.userName,
                                                                  viewerCount: stream.viewerCount,
                                                                  language: stream.streamLanguage,
                                                                  thumbnailUrl: stream.thumbnailUrl))
        }
        return twitchStream
    }
}
