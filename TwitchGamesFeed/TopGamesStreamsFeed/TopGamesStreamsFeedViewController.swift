//
//  TopGamesStreamsFeedViewController.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 02.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

class TopGamesStreamsFeedViewController: UIViewController {
    
    private lazy var slideMenuTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.rowHeight = 58
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(SlideMenuItemCell.self, forCellReuseIdentifier: SlideMenuItemCell.cellId)
        return tv
    }()
    
    private let dotButtonView = DotMenuButton()
    
    private let streamsCollectionViewContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    private lazy var streamsCollectionView: UICollectionView = {
        let streamsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        streamsCollectionView.backgroundColor = .clear
        return streamsCollectionView
    }()
    
    private var isMenuExpanded = false
    private var dragMenuWidth: CGFloat = 0
    
    private let slideMenuItems = ["Best Today", "Categories", "Search", "About App"]
    private var topGamesStreamsViewModel = TopGamesStreamsFeedViewModel()
    private var twitchGames: PublishSubject<[TwitchGame]> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSlideMenuTableView()
        configureStreamsCollectionViewContainerView()
        configureDotViewButton()
        configureStreamsCollectionView()
        configureBindings()
        topGamesStreamsViewModel.fetchGamesList()
        view.backgroundColor = UIColor(red: 85/255, green: 26/255, blue: 173/255, alpha: 1.0)
    }
    
    // MARK: Views configure methods
    
    private func configureBindings() {
        topGamesStreamsViewModel
            .topGames
            .observeOn(MainScheduler.instance)
            .bind(to: self.twitchGames)
            .disposed(by: disposeBag)
        
        twitchGames.bind(to: streamsCollectionView.rx.items(cellIdentifier: "cellId", cellType: TwitchGameCell.self)) {row, game, cell in
            cell.twitchGame = game
        }.disposed(by: disposeBag)
    }
    
    private func configureSlideMenuTableView() {
        view.addSubview(slideMenuTableView)
        
        slideMenuTableView.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func configureStreamsCollectionViewContainerView() {
        view.addSubview(streamsCollectionViewContainerView)
        
        streamsCollectionViewContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragMenu(_:)))
        streamsCollectionViewContainerView.addGestureRecognizer(panGesture)
    }
    
    private func configureStreamsCollectionView() {
        streamsCollectionViewContainerView.addSubview(streamsCollectionView)
        
        streamsCollectionView.showsVerticalScrollIndicator = false
        streamsCollectionView.showsHorizontalScrollIndicator = false
        
        streamsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dotButtonView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        streamsCollectionView.register(TwitchGameCell.self, forCellWithReuseIdentifier: "cellId")
        
        let layout = streamsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 48, height: 180)
        layout.minimumLineSpacing = 24
        layout.scrollDirection = .vertical
    }
    
    private func configureDotViewButton() {
        dotButtonView.onTap = { [weak self] in
            self?.toggleMenu()
        }
        
        streamsCollectionViewContainerView.addSubview(dotButtonView)
        dotButtonView.snp.makeConstraints { make in
            make.leading.equalTo(streamsCollectionViewContainerView.snp.leading).offset(24)
            make.top.equalTo(streamsCollectionViewContainerView.snp.topMargin)
            make.size.equalTo(18)
        }
    }
    
    // MARK: Slide Menu methods
    
    @objc private func dragMenu(_ sender: UIPanGestureRecognizer) {
        let translationX = sender.translation(in: sender.view).x
        let velocityX = sender.velocity(in: sender.view).x
        switch sender.state {
        case .began, .changed:
            dragMenuWidth += translationX
            dragMenuWidth = max(0, dragMenuWidth)
            dragMenuWidth = min(200, dragMenuWidth)
            
            resizeMenu(dragMenuWidth)
            
            sender.setTranslation(.zero, in: sender.view)
        case .ended:
            if self.isMenuExpanded {
                let dismissedByVelocity = velocityX <= -200
                let dismissedByFractionCompleted = dragMenuWidth <= 200 * 0.75
                
                if dismissedByVelocity || dismissedByFractionCompleted {
                    self.isMenuExpanded = false
                }
            } else {
                let presentedByVelocity = velocityX >= 200
                let presentedByFractionCompleted = dragMenuWidth >= 200 * 0.25
                if presentedByVelocity || presentedByFractionCompleted {
                    self.isMenuExpanded = true
                }
            }
            
            dragMenuWidth = self.isMenuExpanded ? 200 : 0
            resizeMenu(dragMenuWidth)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options:  [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                self.view.layoutIfNeeded()
            })
        default:
            break
        }
    }
    
    private func resizeMenu(_ offsetX: CGFloat) {
        streamsCollectionViewContainerView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(offsetX)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(offsetX)
        }
    }

    @objc private func toggleMenu() {
        if !isMenuExpanded {
            streamsCollectionViewContainerView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(view.frame.width * 0.6)
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().offset(view.frame.width * 0.6)
            }
        } else {
            streamsCollectionViewContainerView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { isCompleted in
            self.isMenuExpanded = !self.isMenuExpanded
            self.dragMenuWidth = self.isMenuExpanded ? 200 : 0
        })
    }
}

// MARK: UITableViewDataSource

extension TopGamesStreamsFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        slideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SlideMenuItemCell
        cell.setup(slideMenuItems[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate

extension TopGamesStreamsFeedViewController: UITableViewDelegate {
    // TODO: perform onClick events
}
