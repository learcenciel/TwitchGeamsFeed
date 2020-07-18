//
//  AppCoordinator.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController? = UINavigationController()
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    private let mainCoordinator: TopGamesFeedCoordinator
    
    init(mainCoordinator: TopGamesFeedCoordinator) {
        self.mainCoordinator = mainCoordinator
    }
    
    func start() {
        self.navigationController?.navigationBar.isHidden = true
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        self.mainCoordinator.navigationController = self.navigationController
        self.start(coordinator: mainCoordinator)
    }
}
