//
//  TopGamesStreamsFeedViewController.swift
//  TwitchStreamFeed
//
//  Created by Alexander on 02.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class TopGamesStreamsFeedViewController: UIViewController {
    
    private lazy var screenTypeTitleLabel: UILabel = {
        let screenTitleLabel = UILabel()
        screenTitleLabel.text = "Popular Today"
        screenTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        screenTitleLabel.numberOfLines = 1
        screenTitleLabel.textColor = .black
        screenTitleLabel.textAlignment = .center
        return screenTitleLabel
    }()
    
    private lazy var streamsCollectionView: UICollectionView = {
        let streamsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        streamsCollectionView.backgroundColor = .clear
        return streamsCollectionView
    }()
    
    private lazy var slideMenuTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.rowHeight = 58
        tv.backgroundColor = .clear
        tv.register(SlideMenuItemCell.self, forCellReuseIdentifier: SlideMenuItemCell.cellId)
        return tv
    }()
    
    private let dotButtonView = DotMenuButton()
    
    private let streamsCollectionViewContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    private let disposeBag = DisposeBag()
    
    private var isMenuExpanded = false
    private var dragMenuWidth: CGFloat = 0
    
    private var twitchGames: BehaviorRelay<[GameResponse]> = BehaviorRelay(value: [])
    var topGamesStreamsViewModel: TopGamesStreamsFeedViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 85/255, green: 26/255, blue: 173/255, alpha: 1.0)

        configureBindings()
        configureSlideMenuTableView()
        configureStreamsCollectionViewContainerView()
        configureDotViewButton()
        configureScreenTypeTitleLabel()
        configureStreamsCollectionView()
        
        topGamesStreamsViewModel?.fetchGamesList()
    }
    // MARK: Views configure methods
    
    private func configureBindings() {
        disposeBag += topGamesStreamsViewModel?
            .topGames
            .observeOn(MainScheduler.instance)
            .bind(to: self.twitchGames)
        
        disposeBag += topGamesStreamsViewModel?.slideMenuItems.bind(to: slideMenuTableView.rx.items(cellIdentifier: "cellId", cellType: SlideMenuItemCell.self)) { row, slideMenuItem, cell in
            cell.setup(slideMenuItem.rawValue)
        }
            
        disposeBag += twitchGames.bind(to: streamsCollectionView.rx.items(cellIdentifier: "cellId", cellType: GameCell.self)) { row, game, cell in
            cell.isFavorite = self.topGamesStreamsViewModel!.databaseManager.isFavorite(gameResponse: game)
            cell.twitchGame = game
            cell.onFavoriteChanged = { [weak self] isFavorite in
                isFavorite ?
                    self?.topGamesStreamsViewModel?.databaseManager.saveGame(cell.twitchGame) :
                    self?.topGamesStreamsViewModel?.databaseManager.delete(gameResponse: cell.twitchGame)
            }
        }
        
        disposeBag += slideMenuTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            self.topGamesStreamsViewModel?.slideMenuItemTapped.onNext(SlideMenuItemType.allCases[indexPath.row])
        })
        
        disposeBag += streamsCollectionView.rx.modelSelected(GameResponse.self).subscribe(onNext: { [unowned self] game in
            self.topGamesStreamsViewModel?.gameTapped.onNext(game)
        })
        
        disposeBag += topGamesStreamsViewModel?.gameTapped.subscribe(onNext: { [unowned self] _ in
            if self.isMenuExpanded { self.toggleMenu() }
        })
        
        disposeBag += topGamesStreamsViewModel?.error.subscribe(onNext: { error in
            print(error)
        })
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
    
    private func configureDotViewButton() {
        dotButtonView.onTap = { [weak self] in
            self?.toggleMenu()
        }
        
        streamsCollectionViewContainerView.addSubview(dotButtonView)
        dotButtonView.snp.makeConstraints { make in
            make.leading.equalTo(streamsCollectionViewContainerView.snp.leading).offset(24)
            make.top.equalTo(streamsCollectionViewContainerView.snp.topMargin).offset(14)
            make.size.equalTo(18)
        }
    }
    
    private func configureScreenTypeTitleLabel() {
        self.screenTypeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.streamsCollectionViewContainerView.addSubview(screenTypeTitleLabel)
        self.screenTypeTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dotButtonView)
            make.leading.equalTo(dotButtonView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-24)
        }
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
        
        streamsCollectionView.register(GameCell.self, forCellWithReuseIdentifier: "cellId")
        
        let layout = streamsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 48, height: 180)
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        layout.scrollDirection = .vertical
    }
    
    // MARK: Slide Menu methods
    
    @objc private func dragMenu(_ sender: UIPanGestureRecognizer) {
        let translationX = sender.translation(in: sender.view).x
        let velocityX = sender.velocity(in: sender.view).x
        switch sender.state {
        case .began, .changed:
            dragMenuWidth += translationX
            dragMenuWidth = max(0, dragMenuWidth)
            dragMenuWidth = min(250, dragMenuWidth)
            
            resizeMenu(dragMenuWidth)
            
            sender.setTranslation(.zero, in: sender.view)
        case .ended:
            if self.isMenuExpanded {
                let dismissedByVelocity = velocityX <= -250
                let dismissedByFractionCompleted = dragMenuWidth <= 250 * 0.75
                
                if dismissedByVelocity || dismissedByFractionCompleted {
                    self.isMenuExpanded = false
                }
            } else {
                let presentedByVelocity = velocityX >= 250
                let presentedByFractionCompleted = dragMenuWidth >= 250 * 0.25
                if presentedByVelocity || presentedByFractionCompleted {
                    self.isMenuExpanded = true
                }
            }
            
            dragMenuWidth = self.isMenuExpanded ? 250 : 0
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
            self.dragMenuWidth = self.isMenuExpanded ? 250 : 0
        })
    }
}
