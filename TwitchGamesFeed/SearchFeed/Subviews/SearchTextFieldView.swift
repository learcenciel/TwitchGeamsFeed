//
//  SearchTextField.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 12.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import UIKit

class SearchTextFieldView: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(UIImage(named: "clear_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = .black
            }
        }
    }
}
