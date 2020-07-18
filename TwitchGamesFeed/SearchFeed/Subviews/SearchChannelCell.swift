//
//  TwitchSearchChannelCell.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 15.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Nuke
import SnapKit
import UIKit

class SearchChannelCell: UITableViewCell {
    
    private let channelNameLabel: UILabel = {
        let channelNameLabel = UILabel()
        channelNameLabel.numberOfLines = 2
        channelNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        channelNameLabel.textColor = .black
        return channelNameLabel
    }()
    
    private let channelLogoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFill
        return logoImageView
    }()
    
    private let followersCountLabel: UILabel = {
        let followersCountLabel = UILabel()
        followersCountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        followersCountLabel.textColor = .black
        return followersCountLabel
    }()
    
    private let checkMarkView: CheckMarkView = {
        let checkMarkView = CheckMarkView()
        checkMarkView.backgroundColor = .clear
        return checkMarkView
    }()
        
    var channel: SearchChannel! {
        didSet {
            guard let url = URL(string: channel.logoUrl) else { return }
            Nuke.loadImage(with: url, into: channelLogoImageView)
            channelNameLabel.text = channel.name
            followersCountLabel.text = String(channel.followersCount) + " followers"
            checkMarkView.isHidden = !channel.isPartner
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.channelLogoImageView.image = nil
        self.channelNameLabel.text = ""
        self.followersCountLabel.text = ""
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
        channelLogoImageView.layer.cornerRadius = channelLogoImageView.bounds.height / 2
        channelLogoImageView.clipsToBounds = true
    }
    
    private func configureViews() {
        addSubview(channelLogoImageView)
        addSubview(channelNameLabel)
        addSubview(followersCountLabel)
        addSubview(checkMarkView)
        
        channelLogoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        channelNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(channelLogoImageView.snp.trailing).offset(24)
            make.top.equalTo(channelLogoImageView.snp.top).offset(8)
        }
        
        checkMarkView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.leading.equalTo(channelNameLabel.snp.trailing).offset(14)
            make.centerY.equalTo(channelNameLabel.snp.centerY)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
        }
        
        followersCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(channelNameLabel.snp.leading)
            make.trailing.lessThanOrEqualToSuperview().offset(-24)
            make.top.equalTo(channelNameLabel.snp.bottom).offset(14)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}
