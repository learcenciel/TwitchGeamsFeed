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
    func convertTwitchFeaturedStreamResponse(_ twitchFeaturedStreamResponse: FeaturedStreamsResponse) -> [Stream] {
        
        var twitchStreams: [Stream] = []
        
        for streamResponse in twitchFeaturedStreamResponse.data {
            twitchStreams.append(Stream(title: streamResponse.stream.channel.title,
                                                                  userName: streamResponse.stream.channel.name,
                                                                  viewerCount: streamResponse.stream.viewers,
                                                                  language: streamResponse.stream.channel.language,
                                                                  thumbnailUrl: streamResponse.stream.imageBoxInfo.gameUrlPath))
        }
        
        return twitchStreams
    }
    
    func convertTwitchSearchGameStreamResponse(_ twitchSearchGameStreamResponse: SearchGameStreams) -> [Stream] {
        
        var twitchStreams: [Stream] = []
        
        for stream in twitchSearchGameStreamResponse.data {
            twitchStreams.append(Stream(title: stream.channel.title,
                                                                  userName: stream.channel.name,
                                                                  viewerCount: stream.viewerCount,
                                                                  language: stream.channel.language,
                                                                  thumbnailUrl: stream.imageBoxInfo.gameUrlPath))
        }
        
        return twitchStreams
    }
}
