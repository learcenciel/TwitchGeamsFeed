//
//  TwitchGameCell.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 04.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Nuke
import SnapKit
import UIKit

class TwitchGameCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 3
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let viewersCountLabel: UILabel = {
        let viewersCountLabel = UILabel()
        viewersCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewersCountLabel.numberOfLines = 1
        viewersCountLabel.textAlignment = .left
        viewersCountLabel.textColor = .white
        viewersCountLabel.text = "91,5k viewers"
        return viewersCountLabel
    }()
    
    var twitchGame: TwitchGameResponse! {
        didSet {
            let prepString = twitchGame.game.imageBox.gameUrlPath.replacingOccurrences(of: "{width}x{height}", with: "720x1136")
            guard let url = URL(string: prepString) else { return }
            Nuke.loadImage(with: url, into: posterImageView)
            titleLabel.text = twitchGame.game.name
            viewersCountLabel.text = "\(twitchGame.viewersCount) viewers"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
    
    private func configureViews() {
        addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(viewersCountLabel)
        containerView.layer.cornerRadius = 18
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor(red: 85/255, green: 26/255, blue: 173/255, alpha: 1.0)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(posterImageView.snp.height).multipliedBy(Float(3)/Float(4))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(14)
            make.trailing.lessThanOrEqualTo(containerView.snp.trailing).offset(-14)
        }
        
        viewersCountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(containerView.snp.trailing).offset(-14)
        }
    }
}
