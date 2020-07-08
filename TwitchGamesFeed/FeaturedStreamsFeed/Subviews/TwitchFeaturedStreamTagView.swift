//
//  TwitchFeaturedStreamTagView.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 07.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import SnapKit
import UIKit

class TwitchFeaturedStreamTagView: UIView {
    
    private let tagLabel: UILabel = {
        let liveTitleLabel = UILabel()
        liveTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        liveTitleLabel.textColor = .black
        return liveTitleLabel
    }()
    
    var streamTag: String = "" {
        didSet {
            self.tagLabel.text = streamTag.uppercased()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        layer.cornerRadius = 4
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitle() {
        addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.tagLabel.intrinsicContentSize.width + 4, height: self.tagLabel.intrinsicContentSize.height + 4)
    }
}
