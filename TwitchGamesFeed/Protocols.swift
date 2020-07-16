//
//  Protocols.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
}

extension Coordinator {
    func start(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }
}

protocol SearchTypeSegmentedControlDelegate {
    func didSelect(item at: Int)
}

protocol SearchCapable: UITableViewDelegate, UITableViewDataSource {
    func search(query: String, offset: Int)
}

protocol StreamSearchControllerDelegate {
    var searchFeedViewModel: SearchFeedViewModel! { get set }
    func didRetreiveStreams()
    func didSelectStream(twitchStream: Stream)
}

protocol ChannelSearchControllerDelegate {
    var searchFeedViewModel: SearchFeedViewModel! { get set }
    func didRetreiveChannels()
    func didSelectChannel(channel: SearchChannel)
}
