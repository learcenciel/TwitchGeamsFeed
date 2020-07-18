//
//  FavoriteGamesFeedCoordinator.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity
import Foundation
import RxSwift
import UIKit

class FavoriteGamesFeedCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    private let container: DIContainer
    let favoriteGamesFeedViewController: FavoriteGamesFeedViewController
    let favoriteGamesFeedViewModel: FavoriteGamesFeedViewModel
    
    init(favoriteGamesFeedViewController: FavoriteGamesFeedViewController,
         favoriteGamesFeedViewModel: FavoriteGamesFeedViewModel,
         container: DIContainer) {
        self.favoriteGamesFeedViewController = favoriteGamesFeedViewController
        self.favoriteGamesFeedViewModel = favoriteGamesFeedViewModel
        self.container = container
    }
    
    func start() {
        self.navigationController?.delegate = self
        self.favoriteGamesFeedViewController.favoriteGamesFeedViewModel = self.favoriteGamesFeedViewModel
        self.favoriteGamesFeedViewModel.gameTapped.subscribe(onNext: { [unowned self] gameResponse in
            let topGamesFeedCoordinator =
                self.instantiateTwitchStreamsFeedCoordinator(with: gameResponse.game.name,
                                                             streamType: .gameCategory(gameResponse.game.name))
            self.start(coordinator: topGamesFeedCoordinator)
        }).disposed(by: disposeBag)
        
        self.navigationController?.pushViewController(self.favoriteGamesFeedViewController, animated: true)
    }
    
    private func instantiateTwitchStreamsFeedCoordinator(with title: String, streamType: StreamType) -> StreamsFeedCoordinator {
        let twitchStreamsFeedCoordinator: StreamsFeedCoordinator = *self.container
        twitchStreamsFeedCoordinator.navigationController = self.navigationController
        twitchStreamsFeedCoordinator.streamsFeedViewController.title = title
        twitchStreamsFeedCoordinator.streamsFeedViewModel.streamType = streamType
        return twitchStreamsFeedCoordinator
    }
}

extension FavoriteGamesFeedCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !navigationController.children.contains(self.favoriteGamesFeedViewController) {
            self.parentCoordinator?.didFinish(coordinator: self)
        }
    }
}
