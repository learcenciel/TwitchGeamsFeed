//
//  CheckMarkView.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 15.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import UIKit

class CheckMarkView: UIView {
    
    // MARK: Layer properties
    
    private var ovalLayer = CAShapeLayer()
    private var checkMarkLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
        setNeedsDisplay()
    }
    
    private func updatePaths() {
        let ovalPath = UIBezierPath(ovalIn: bounds)
        ovalLayer.path = ovalPath.cgPath
        
        let checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: bounds.width / 4, y: bounds.height / 2 + 2))
        checkMarkPath.addLine(to: CGPoint(x: bounds.width / 2.5, y: bounds.height - 4))
        checkMarkPath.addLine(to: CGPoint(x: bounds.width / 1.5, y: 4))
        checkMarkLayer.path = checkMarkPath.cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        createOval()
        createCheckMark()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func createOval() {
        ovalLayer.fillColor = UIColor.purple.cgColor
        layer.addSublayer(ovalLayer)
    }
    
    private func createCheckMark() {
        checkMarkLayer.strokeColor = UIColor.white.cgColor
        checkMarkLayer.fillColor = UIColor.clear.cgColor
        checkMarkLayer.lineWidth = 3
        checkMarkLayer.lineCap = .round
        layer.addSublayer(checkMarkLayer)
    }
}
    




