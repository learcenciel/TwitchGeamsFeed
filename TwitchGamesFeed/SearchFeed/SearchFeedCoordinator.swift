//
//  TwitchSearchFeedCoordinator.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 12.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity
import Foundation
import RxSwift
import UIKit

class SearchFeedCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    private let container: DIContainer
    private let twitchSearchFeedViewModel: SearchFeedViewModel
    let twitchSearchFeedViewController: SearchFeedViewController
    
    init(twitchSearchFeedViewController: SearchFeedViewController,
         twitchSearchFeedViewModel: SearchFeedViewModel,
         container: DIContainer) {
        self.twitchSearchFeedViewController = twitchSearchFeedViewController
        self.twitchSearchFeedViewModel = twitchSearchFeedViewModel
        self.container = container
    }
    
    func start() {
        self.twitchSearchFeedViewController.searchFeedViewModel = self.twitchSearchFeedViewModel
        
        disposeBag += self.twitchSearchFeedViewModel.searchStreamTapped
            .subscribe(onNext: { [unowned self] streamUrl in
                guard
                    let wkVC = self.instantiateWebKitViewController(with: streamUrl.userName)
                    else { return }
                self.navigationController?.pushViewController(wkVC, animated: true)
            })
        
        disposeBag += self.twitchSearchFeedViewModel.searchChannelTapped
            .subscribe(onNext: { [unowned self] channel in
                guard
                    let wkVC = self.instantiateWebKitViewController(with: channel.url)
                    else { return }
                self.navigationController?.pushViewController(wkVC, animated: true)
            })
        
        instantiateSearchCapables()
        self.navigationController?.pushViewController(self.twitchSearchFeedViewController, animated: true)
    }
    
    private func instantiateSearchCapables() {
        var searchControllers: [SearchCapable] = []
        
        let streamSearchController: StreamSearchController = *container
        streamSearchController.delegate = self.twitchSearchFeedViewController
        
        let channelSearchController: ChannelSearchController = *container
        channelSearchController.delegate = self.twitchSearchFeedViewController
        
        searchControllers.append(streamSearchController)
        searchControllers.append(channelSearchController)
        
        self.twitchSearchFeedViewController.searchControllers = searchControllers
        self.twitchSearchFeedViewController.currentSearchController = searchControllers[0]
    }
    
    private func instantiateWebKitViewController(with url: String) -> WebKitViewController? {
        let wkVC = WebKitViewController()
        guard
            let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else { return nil }
        wkVC.streamUrl = encodedUrl
        return wkVC
    }
}
