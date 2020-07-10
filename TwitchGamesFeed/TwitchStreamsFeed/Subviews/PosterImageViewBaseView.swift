//
//  PosterImageViewBaseView.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 08.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import SnapKit
import UIKit

class PosterImageViewBaseView: UIView {
    
    var labelFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium) {
        didSet {
            self.posterBaseViewLabel.font = labelFont
        }
    }
    
    var labelTitle: String? {
        didSet {
            self.posterBaseViewLabel.text = labelTitle
        }
    }
    
    var fontColor: UIColor? {
        didSet {
            self.posterBaseViewLabel.textColor = fontColor
        }
    }
    
    private let posterBaseViewLabel: UILabel = {
        let liveTitleLabel = UILabel()
        liveTitleLabel.text = "Base View"
        liveTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        addSubview(posterBaseViewLabel)
        posterBaseViewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.posterBaseViewLabel.intrinsicContentSize.width + 4, height: self.posterBaseViewLabel.intrinsicContentSize.height + 4)
    }
}
