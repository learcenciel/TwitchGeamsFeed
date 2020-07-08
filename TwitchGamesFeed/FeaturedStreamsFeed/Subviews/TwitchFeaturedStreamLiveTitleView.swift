//
//  TwitchFeaturedStreamLiveTitleView.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import SnapKit
import UIKit

class TwitchFeaturedStreamLiveTitleView: UIView {
    
    private let liveTitleLabel: UILabel = {
        let liveTitleLabel = UILabel()
        liveTitleLabel.text = "Live"
        liveTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        liveTitleLabel.textColor = .white
        return liveTitleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .red
        layer.cornerRadius = 4
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitle() {
        addSubview(liveTitleLabel)
        liveTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.liveTitleLabel.intrinsicContentSize.width + 4, height: self.liveTitleLabel.intrinsicContentSize.height + 4)
    }
}
