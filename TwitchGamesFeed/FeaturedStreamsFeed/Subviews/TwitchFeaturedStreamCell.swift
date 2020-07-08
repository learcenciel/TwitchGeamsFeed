//
//  TwitchFeaturedStreamCell.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Nuke
import SnapKit
import UIKit

class TwitchFeaturedStreamCell: UICollectionViewCell {
    
    private let mainContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let upperContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let bottomContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let liveTitleView = TwitchFeaturedStreamLiveTitleView()
    
    private let posterImageContaierView: UIView = {
        let posterImageContaierView = UIView()
        return posterImageContaierView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let viewersCountLabel =  TwitchFeaturedStreamViewersCountView()
    
    private let gameTagLabel = TwitchFeaturedStreamTagView()
    
    var featuredStream: FeaturedResponse! {
        didSet {
            let prepString = featuredStream.thumbnailUrl.replacingOccurrences(of: "{width}x{height}", with: "720x1136")
            guard let url = URL(string: prepString) else { return }
            Nuke.loadImage(with: url, into: posterImageView)
            titleLabel.text = featuredStream.streamTitle
            viewersCountLabel.viewersCount = featuredStream.viewerCount
            gameTagLabel.streamTag = featuredStream.streamLanguage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
        self.posterImageContaierView.backgroundColor = .black
        self.titleLabel.text = ""
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        upperContainerView.layer.shadowColor = UIColor.black.cgColor
        upperContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        upperContainerView.layer.shadowOpacity = 0.4
        upperContainerView.layer.shadowRadius = 2
    }
    
    private func configureViews() {
        addSubview(mainContainerView)
        
        mainContainerView.addSubview(upperContainerView)
        mainContainerView.addSubview(bottomContainerView)
        
        upperContainerView.addSubview(posterImageContaierView)
        
        posterImageView.addSubview(viewersCountLabel)
        posterImageView.addSubview(liveTitleView)
        
        bottomContainerView.addSubview(titleLabel)
        bottomContainerView.addSubview(gameTagLabel)
        
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        upperContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(frame.height * 0.75)
        }
        upperContainerView.clipsToBounds = false
        
        bottomContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(upperContainerView.snp.bottom)
        }
        
        posterImageContaierView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageContaierView.clipsToBounds = true
        posterImageContaierView.layer.cornerRadius = 14
        posterImageContaierView.addSubview(posterImageView)

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        posterImageView.addSubview(liveTitleView)
        
        liveTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(14)
        }

        viewersCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }

        gameTagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalToSuperview()
        }
        
        gameTagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(gameTagLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
