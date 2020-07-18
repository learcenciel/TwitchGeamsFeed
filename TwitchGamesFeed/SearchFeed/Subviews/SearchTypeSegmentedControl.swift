//
//  File.swift
//  SearchTypeSegmentedControl
//
//  Created by Alexander on 14.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import SnapKit
import UIKit

class SearchTypeSegmentedControl: UIControl {

    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor: UIColor = .black
    var selectorViewColor: UIColor = UIColor(red: 85/255, green: 26/255, blue: 173/255, alpha: 1.0)
    var selectorTextColor: UIColor = UIColor(red: 85/255, green: 26/255, blue: 173/255, alpha: 1.0)
    
    var delegate: SearchTypeSegmentedControlDelegate?
    
    init(frame: CGRect, buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
    
    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        self.configureView()
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureSelectorView() {
        let selectorWidth = bounds.width / CGFloat(self.buttons.count)
        
        let selectorViewRect = CGRect(x: 0,
                                      y: self.bounds.height,
                                      width: selectorWidth,
                                      height: 2)
        selectorView = UIView(frame: selectorViewRect)
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func configureView() {
        createButtons()
        configureSelectorView()
        configureStackView()
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        for (buttonIndex, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            if button == sender {
                let selectorPosition =
                    self.bounds.width / CGFloat(self.buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                button.setTitleColor(selectorTextColor, for: .normal)
                delegate?.didSelect(item: buttonIndex)
            }
        }
    }
}
