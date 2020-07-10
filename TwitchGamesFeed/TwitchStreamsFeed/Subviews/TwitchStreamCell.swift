//
//  TwitchStreamCell.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 10.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Nuke
import SnapKit
import UIKit

class TwitchStreamCell: UITableViewCell {
    
    private let liveTitleView: PosterImageViewBaseView = {
        let liveTitleView = PosterImageViewBaseView()
        liveTitleView.labelFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        liveTitleView.labelTitle = "Live"
        liveTitleView.fontColor = .white
        return liveTitleView
    }()
    
    private let shadowPosterContainerView: UIView = {
        let shadowPosterContainerView = UIView()
        return shadowPosterContainerView
    }()
    
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
    
    private let viewersCountLabel: PosterImageViewBaseView = {
        let viewersCountLabel = PosterImageViewBaseView()
        viewersCountLabel.labelFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        viewersCountLabel.backgroundColor = .black
        viewersCountLabel.fontColor = .white
        return viewersCountLabel
    }()
    
    private let gameTagLabel: PosterImageViewBaseView = {
        let gameTagLabel = PosterImageViewBaseView()
        gameTagLabel.labelFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        gameTagLabel.fontColor = .black
        gameTagLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return gameTagLabel
    }()
    
    //private let gameTagLabel = TwitchFeaturedStreamTagView()
    
    var featuredStream: TwitchStreamInfo! {
        didSet {
            let prepString = featuredStream.thumbnailUrl.replacingOccurrences(of: "{width}x{height}", with: "720x1136")
            guard let url = URL(string: prepString) else { return }
            Nuke.loadImage(with: url, into: posterImageView)
            titleLabel.text = featuredStream.title
            viewersCountLabel.labelTitle = String(featuredStream.viewerCount)
            gameTagLabel.labelTitle = featuredStream.language.uppercased()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
        self.posterImageContaierView.backgroundColor = .black
        self.titleLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowPosterContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowPosterContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowPosterContainerView.layer.shadowOpacity = 0.3
        shadowPosterContainerView.layer.shadowRadius = 2
    }
    
    private func configureViews() {
        
        addSubview(shadowPosterContainerView)
        shadowPosterContainerView.addSubview(posterImageContaierView)
        
        posterImageContaierView.addSubview(posterImageView)
        posterImageView.addSubview(viewersCountLabel)
        posterImageView.addSubview(liveTitleView)
        
        addSubview(titleLabel)
        addSubview(gameTagLabel)
        shadowPosterContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(self.shadowPosterContainerView.snp.width).multipliedBy(CGFloat(9) / CGFloat(16))
        }
        
        posterImageContaierView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        posterImageContaierView.clipsToBounds = true
        posterImageContaierView.layer.cornerRadius = 14

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
            make.leading.equalToSuperview().offset(24)
        }
        gameTagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageContaierView.snp.bottom).offset(10)
            make.leading.equalTo(gameTagLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-28)
        }
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
