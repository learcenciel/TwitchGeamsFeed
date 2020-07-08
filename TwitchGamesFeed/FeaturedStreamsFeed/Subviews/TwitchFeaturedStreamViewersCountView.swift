//
//  TwitchFeaturedStreamViewersCountView.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 07.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import SnapKit
import UIKit

class TwitchFeaturedStreamViewersCountView: UIView {
    
    private let viewersCountLabel: UILabel = {
        let liveTitleLabel = UILabel()
        liveTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        liveTitleLabel.textColor = .white
        return liveTitleLabel
    }()
    
    var viewersCount: Int = 0 {
        didSet {
            self.viewersCountLabel.text = "\(viewersCount) viewers"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .black
        layer.cornerRadius = 4
        configureTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitle() {
        addSubview(viewersCountLabel)
        viewersCountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.viewersCountLabel.intrinsicContentSize.width + 4, height: self.viewersCountLabel.intrinsicContentSize.height + 4)
    }
}
