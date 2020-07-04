//
//  DotMenuButton.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 03.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import UIKit

class DotMenuButton: UIView {

    var onTap: (() -> Void)?
    
    private let dotLayer = CAShapeLayer()
    private let horizontalReplicatorLayer = CAReplicatorLayer()
    private let verticalReplicatorLayer = CAReplicatorLayer()
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addGestureRecognizer(tapGestureRecognizer)
        configureLayers()
    }
    
    private func configureLayers() {
        dotLayer.bounds.size = CGSize(width: 4, height: 4)
        dotLayer.fillColor = UIColor.black.cgColor
        
        layer.addSublayer(horizontalReplicatorLayer)
        layer.addSublayer(verticalReplicatorLayer)
        
        horizontalReplicatorLayer.instanceCount = 2
        horizontalReplicatorLayer.addSublayer(dotLayer)

        verticalReplicatorLayer.instanceCount = 2
        verticalReplicatorLayer.addSublayer(horizontalReplicatorLayer)
    }
    
    private func updateLayers() {
        dotLayer.frame.origin = .zero
        dotLayer.path = CGPath(ellipseIn: dotLayer.bounds, transform: nil)
        
        horizontalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(bounds.width - 4, 0, 0)
        verticalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, bounds.width - 4, 0)

        horizontalReplicatorLayer.frame = bounds
        verticalReplicatorLayer.frame = bounds
    }
    
    @objc private func onTap(_ sender: UITapGestureRecognizer) {
        onTap?()
    }
}
