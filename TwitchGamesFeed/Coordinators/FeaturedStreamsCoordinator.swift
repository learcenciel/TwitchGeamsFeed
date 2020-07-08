//
//  FeaturedStreamsCoordinator.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class FeaturedStreamsCoordinator: NSObject, Coordinator {
    
    var navigationController: UINavigationController?
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let disposeBag = DisposeBag()
    private let featuredStreamsViewController: FeaturedStreamsViewController
    private let featuredStreamsViewModel: FeaturedStreamsViewModel
    
    init(featuredStreamsViewController: FeaturedStreamsViewController,
                  featuredStreamsViewModel: FeaturedStreamsViewModel) {
        self.featuredStreamsViewController = featuredStreamsViewController
        self.featuredStreamsViewModel = featuredStreamsViewModel
    }
    
    func start() {
        self.navigationController?.delegate = self
        self.featuredStreamsViewController.featuredStreamsViewModel = self.featuredStreamsViewModel
        disposeBag += self.featuredStreamsViewModel.featuredStreamTapped
            .subscribe(onNext: { [unowned self] streamUrl in
                let wkVC = WebKitViewController()
                wkVC.streamUrl = streamUrl.userName
                self.navigationController?.pushViewController(wkVC, animated: true)
            })
        
        self.navigationController?.pushViewController(self.featuredStreamsViewController, animated: true)
    }
}

extension FeaturedStreamsCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !navigationController.children.contains(self.featuredStreamsViewController) {
            self.parentCoordinator?.didFinish(coordinator: self)
        }
    }
}
