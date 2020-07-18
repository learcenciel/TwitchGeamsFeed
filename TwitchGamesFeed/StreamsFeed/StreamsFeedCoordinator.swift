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

class StreamsFeedCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    let streamsFeedViewController: StreamsFeedViewController
    let streamsFeedViewModel: StreamsFeedViewModel
    
    init(twitchStreamsFeedViewController: StreamsFeedViewController,
         twitchStreamsFeedViewModel: StreamsFeedViewModel) {
        self.streamsFeedViewController = twitchStreamsFeedViewController
        self.streamsFeedViewModel = twitchStreamsFeedViewModel
    }
    
    func start() {
        self.navigationController?.delegate = self
        self.streamsFeedViewController.featuredStreamsViewModel = self.streamsFeedViewModel
        disposeBag += self.streamsFeedViewModel.featuredStreamTapped
            .subscribe(onNext: { [unowned self] streamUrl in
                let wkVC = WebKitViewController()
                wkVC.streamUrl = streamUrl.userName
                self.navigationController?.pushViewController(wkVC, animated: true)
            })
        self.navigationController?.pushViewController(self.streamsFeedViewController, animated: true)
    }
}

extension StreamsFeedCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !navigationController.children.contains(self.streamsFeedViewController) {
            self.parentCoordinator?.didFinish(coordinator: self)
        }
    }
}
