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
        
        self.topGamesFeedViewModel.gameTapped.subscribe(onNext: { game in
            //            self.featuredStreamsCoordinator.navigationController = self.navigationController
            //            self.start(coordinator: self.featuredStreamsCoordinator)
            // TODO: Transition to streams of the chosen game
        }).disposed(by: disposeBag)
        
        self.topGamesFeedViewModel.featuredStreamsItemMenuTapped.subscribe(onNext: { [unowned self] slideMenuItemType in
            switch slideMenuItemType {
            case .featuredStreams:
                let featuredStreamsCoordinator: FeaturedStreamsCoordinator = *self.container
                featuredStreamsCoordinator.navigationController = self.navigationController
                self.start(coordinator: featuredStreamsCoordinator)
            case .aboutApp:
                break
            case .search:
                break
            }
        }).disposed(by: disposeBag)
    }
}
