//
//  TopGamesFeedCoordinator.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity
import Foundation
import RxSwift
import UIKit

enum SlideMenuItemType: String, CaseIterable {
    case featuredStreams = "Featured Streams"
    case favoriteGames = "Favorite Games"
    case search = "Search"
    case aboutApp = "About App"
}

class TopGamesFeedCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    private let topGamesFeedViewController: TopGamesStreamsFeedViewController
    private let topGamesFeedViewModel: TopGamesStreamsFeedViewModel
    private let container: DIContainer
    
    init(topGamesFeedViewController: TopGamesStreamsFeedViewController,
         topGamesFeedViewModel: TopGamesStreamsFeedViewModel,
         container: DIContainer) {
        self.topGamesFeedViewController = topGamesFeedViewController
        self.topGamesFeedViewModel = topGamesFeedViewModel
        self.container = container
    }
    
    func start() {
        self.topGamesFeedViewController.topGamesStreamsViewModel = self.topGamesFeedViewModel
        self.topGamesFeedViewModel.slideMenuItems.accept(SlideMenuItemType.allCases)
        self.navigationController?.viewControllers = [self.topGamesFeedViewController]
        
        self.topGamesFeedViewModel.gameTapped.subscribe(onNext: { gameResponse in
            let topGamesFeedCoordinator =
                self.instantiateTwitchStreamsFeedCoordinator(with: gameResponse.game.name,
                                                             streamType: .gameCategory(gameResponse.game.name))
            self.start(coordinator: topGamesFeedCoordinator)
        }).disposed(by: disposeBag)
        
        self.topGamesFeedViewModel.slideMenuItemTapped.subscribe(onNext: { [unowned self] slideMenuItemType in
            switch slideMenuItemType {
            case .featuredStreams:
                let twitchStreamFeedCoordinator = self.instantiateTwitchStreamsFeedCoordinator(with: "Featured", streamType: .featured)
                self.start(coordinator: twitchStreamFeedCoordinator)
            case .favoriteGames:
                let twitchFavoriteGamesFeedCoordinator = self.instantiateTwitchFavoriteGamesFeedCoordinator(with: "Favorite")
                self.start(coordinator: twitchFavoriteGamesFeedCoordinator)
            case .aboutApp:
                break
            case .search:
                let twitchSearchFeedCoordinator = self.insantiateTwitchSearchFeedCoordinator(with: "Search")
                self.start(coordinator: twitchSearchFeedCoordinator)
            }
        }).disposed(by: disposeBag)
    }
    
    private func instantiateTwitchStreamsFeedCoordinator(with title: String, streamType: StreamType) -> StreamsFeedCoordinator {
        let twitchStreamsFeedCoordinator: StreamsFeedCoordinator = *self.container
        twitchStreamsFeedCoordinator.navigationController = self.navigationController
        twitchStreamsFeedCoordinator.streamsFeedViewController.title = title
        twitchStreamsFeedCoordinator.streamsFeedViewModel.streamType = streamType
        return twitchStreamsFeedCoordinator
    }
    
    private func insantiateTwitchSearchFeedCoordinator(with title: String) -> SearchFeedCoordinator {
        let twitchSearchFeedCoordinator: SearchFeedCoordinator = *self.container
        twitchSearchFeedCoordinator.navigationController = self.navigationController
        twitchSearchFeedCoordinator.twitchSearchFeedViewController.title = title
        return twitchSearchFeedCoordinator
    }
    
    private func instantiateTwitchFavoriteGamesFeedCoordinator(with title: String) -> FavoriteGamesFeedCoordinator {
        let twitchFavoriteGamesFeedCoordinator: FavoriteGamesFeedCoordinator = *self.container
        twitchFavoriteGamesFeedCoordinator.navigationController = self.navigationController
        twitchFavoriteGamesFeedCoordinator.favoriteGamesFeedViewController.title = title
        return twitchFavoriteGamesFeedCoordinator
    }
}
