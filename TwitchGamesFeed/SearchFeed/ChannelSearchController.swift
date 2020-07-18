//
//  ChannelSearchController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 15.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation

import UIKit

class ChannelSearchController: NSObject {
    
    private let twitchAPI: TwitchAPI
    private var twitchChannels =  [SearchChannel]()
    
    private var query: String = ""
    private var offset: Int = 0
    private var isDownloading = false
    
    private var heightDictionary: [IndexPath: CGFloat] = [:]
    var contentOffset: CGPoint = .zero
    
    var delegate: ChannelSearchControllerDelegate?
    
    init(twitchAPI: TwitchAPI) {
        self.twitchAPI = twitchAPI
    }
    
    private func fetchChannels(query: String, offset: Int) {
        twitchAPI.fetchChannels(parameters: ["query": query,
                                             "offset": offset]) { result in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)
                                                case .success(let response):
                                                    self.twitchChannels = response.data
                                                    self.delegate?.didRetreiveChannels()
                                                }
        }
    }
    
    private func fetchMoreChannels(query: String, offset: Int) {
        twitchAPI.fetchChannels(parameters: ["query": query,
                                             "offset": offset]) { result in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)
                                                case .success(let response):
                                                    self.twitchChannels.append(contentsOf: response.data)
                                                    self.isDownloading = false
                                                    self.delegate?.didRetreiveChannels()
                                                }
        }
    }
}

extension ChannelSearchController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        heightDictionary[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightDictionary[indexPath] ?? UITableView.automaticDimension
    }
}

extension ChannelSearchController: SearchCapable {
    func search(query: String, offset: Int) {
        if self.query != query {
            self.query = query
            fetchChannels(query: query, offset: offset)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitchChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let count = self.twitchChannels.count
        if count > 1 && indexPath.row == count - 1 && self.isDownloading == false {
            self.offset += 10
            self.isDownloading = true
            fetchMoreChannels(query: self.query, offset: self.offset)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath) as! SearchChannelCell
        cell.channel = self.twitchChannels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelTapped = self.twitchChannels[indexPath.row]
        delegate?.searchFeedViewModel.searchChannelTapped.onNext(channelTapped)
    }
}
