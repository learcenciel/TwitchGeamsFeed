//
//  AppDelegate.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 05.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import DITranquillity
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let container = DIContainer()
        container.append(framework: AppFramework.self)
        
        if container.validate(checkGraphCycles: true) == false {
            fatalError()
        }
        
        container.initializeSingletonObjects()
        
        let appCoordinator: AppCoordinator = container.resolve()
        appCoordinator.start()
        return true
    }
}

