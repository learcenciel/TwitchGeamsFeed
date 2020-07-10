//
//  TwitchStreamsFeedCoordinator.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 10.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class TwitchStreamsFeedCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    private let twitchStreamsFeedViewController: TwitchStreamsFeedViewController
    private let twitchStreamsFeedViewModel: TwitchStreamsFeedViewModel
    
    init(twitchStreamsFeedViewController: TwitchStreamsFeedViewController,
                  twitchStreamsFeedViewModel: TwitchStreamsFeedViewModel) {
        self.twitchStreamsFeedViewController = twitchStreamsFeedViewController
        self.twitchStreamsFeedViewModel = twitchStreamsFeedViewModel
    }
    
    func start() {
        self.navigationController?.delegate = self
        self.twitchStreamsFeedViewController.featuredStreamsViewModel = self.twitchStreamsFeedViewModel
        disposeBag += self.twitchStreamsFeedViewModel.featuredStreamTapped
            .subscribe(onNext: { [unowned self] streamUrl in
                let wkVC = WebKitViewController()
                wkVC.streamUrl = streamUrl.userName
                self.navigationController?.pushViewController(wkVC, animated: true)
            })
        
        self.navigationController?.pushViewController(self.twitchStreamsFeedViewController, animated: true)
    }
}

extension TwitchStreamsFeedCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !navigationController.children.contains(self.twitchStreamsFeedViewController) {
            self.parentCoordinator?.didFinish(coordinator: self)
        }
    }
}
