//
//  UIVIewController + Extensions.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureNavigationBarBeforeAppear() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    func configureNavigationBarBeforeDisappear() {
        self.navigationController?.navigationBar.isHidden = true
    }
}
