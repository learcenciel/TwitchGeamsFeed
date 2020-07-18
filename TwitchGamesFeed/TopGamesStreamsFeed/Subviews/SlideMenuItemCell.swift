//
//  SlideMenuItemCell.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 02.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import SnapKit
import UIKit

class SlideMenuItemCell: UITableViewCell {
    
    static let cellId = "cellId"
    
    private let menuItemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(menuItemLabel)
        
        menuItemLabel.snp.makeConstraints { make in
            make.leading.equalTo(18)
            make.centerX.equalTo(self)
            make.top.equalTo(8).priority(999)
            make.bottom.equalTo(8).priority(999)
        }
    }
    
    func setup(_ name: String) {
        self.menuItemLabel.text = name
    }
}
