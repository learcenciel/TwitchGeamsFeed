//
//  StreamSearchController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 14.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import UIKit

class StreamSearchController: NSObject {
    
    private let twitchAPI: TwitchAPI
    private let twitchStreamsFeedModelConverter: TwitchStreamsFeedModelConverter
    private var twitchStreams =  [Stream]()
    
    private var query: String = ""
    private var offset: Int = 0
    private var isDownloading = false
    
    var delegate: StreamSearchControllerDelegate?
    
    init(twitchAPI: TwitchAPI,
         twitchStreamsFeedModelConverter: TwitchStreamsFeedModelConverter) {
        self.twitchAPI = twitchAPI
        self.twitchStreamsFeedModelConverter = twitchStreamsFeedModelConverter
    }
    
    private func fetchStreams(query: String, offset: Int) {
        twitchAPI.fetchStreams(parameters: ["query": query,
                                            "offset": self.offset]) { result in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)
                                                case .success(let response):
                                                    let convertedModel =
                                                        self.twitchStreamsFeedModelConverter.convertTwitchSearchGameStreamResponse(response)
                                                    self.twitchStreams = convertedModel
                                                    self.delegate?.didRetreiveStreams()
                                                }
        }
    }
    
    private func fetchMoreStreams(query: String, offset: Int) {
        twitchAPI.fetchStreams(parameters: ["query": query,
                                            "offset": self.offset]) { result in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)
                                                case .success(let response):
                                                    let convertedModel =
                                                        self.twitchStreamsFeedModelConverter.convertTwitchSearchGameStreamResponse(response)
                                                    self.twitchStreams.append(contentsOf: convertedModel)
                                                    self.isDownloading = false
                                                    self.delegate?.didRetreiveStreams()
                                                }
        }
    }
}

extension StreamSearchController: SearchCapable {
    func search(query: String, offset: Int) {
        if self.query != query {
            self.query = query
            fetchStreams(query: query, offset: self.offset)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitchStreams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let count = self.twitchStreams.count
        if count > 1 && indexPath.row == count - 1 && self.isDownloading == false {
            self.offset += 10
            self.isDownloading = true
            fetchMoreStreams(query: self.query, offset: self.offset)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId1", for: indexPath) as! StreamCell
        cell.featuredStream = self.twitchStreams[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let streamTapped = self.twitchStreams[indexPath.row]
        delegate?.searchFeedViewModel.searchStreamTapped.onNext(streamTapped)
    }
}
