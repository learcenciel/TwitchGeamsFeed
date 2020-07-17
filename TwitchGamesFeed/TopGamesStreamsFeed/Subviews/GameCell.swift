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

class GameCell: UICollectionViewCell {
    
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
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        let imageOff = UIImage(named: "like_off")
        likeButton.setImage(imageOff, for: .normal)
        return likeButton
    }()
            
    var isFavorite: Bool = false
    var onFavoriteChanged: ((Bool) -> Void)?
    
    var twitchGame: GameResponse! {
        didSet {
            let prepString = twitchGame.game.imageBox.gameUrlPath.replacingOccurrences(of: "{width}x{height}", with: "720x1136")
            guard let url = URL(string: prepString) else { return }
            Nuke.loadImage(with: url, into: posterImageView)
            titleLabel.text = twitchGame.game.name
            viewersCountLabel.text = "\(twitchGame.viewersCount) viewers"
            isFavorite ?
                self.likeButton.setImage(UIImage(named: "like_on"), for: .normal) :
                self.likeButton.setImage(UIImage(named: "like_off"), for: .normal)
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
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateGame(_:)), name: .didUpdateGame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didUpdateGame, object: nil)
    }
    
    @objc func didUpdateGame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: RealmGameNotification],
            let gameNotification = userInfo["game"]
        else { return }
        
        if gameNotification.gameId == self.twitchGame.game.id {
            gameNotification.isFavorite ?
                self.likeButton.setImage(UIImage(named: "like_on"), for: .normal) :
                self.likeButton.setImage(UIImage(named: "like_off"), for: .normal)
        }
    }
    
    @objc func likeButtonPressed(_ sender: UIButton) {
        self.isFavorite = !self.isFavorite
        self.onFavoriteChanged?(isFavorite)
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
        containerView.addSubview(likeButton)
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
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.width.equalTo(24)
        }
        likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
    }
}
