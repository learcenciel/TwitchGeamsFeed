//
//  FavoriteGamesFeedViewController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class FavoriteGamesFeedViewController: UIViewController {
    
    private lazy var streamsCollectionView: UICollectionView = {
        let streamsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        streamsCollectionView.backgroundColor = .clear
        return streamsCollectionView
    }()
    
    private var twitchGames: PublishSubject<[GameResponse]> = PublishSubject()
    private let disposeBag = DisposeBag()
    var favoriteGamesFeedViewModel: FavoriteGamesFeedViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureStreamsCollectionView()
        configureBindings()
        favoriteGamesFeedViewModel?.fetchGamesList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Views configure methods
    
    private func configureBindings() {
        disposeBag += favoriteGamesFeedViewModel?
            .topGames
            .observeOn(MainScheduler.instance)
            .bind(to: self.twitchGames)
            
        disposeBag += twitchGames.bind(to: streamsCollectionView.rx.items(cellIdentifier: "cellId", cellType: GameCell.self)) { row, game, cell in
            cell.isFavorite = self.favoriteGamesFeedViewModel!.databaseManager.isFavorite(gameResponse: game)
            cell.twitchGame = game
            cell.onFavoriteChanged = { [weak self] isFavorite in
                isFavorite ?
                    self?.favoriteGamesFeedViewModel?.databaseManager.saveGame(cell.twitchGame) :
                    self?.favoriteGamesFeedViewModel?.databaseManager.delete(gameResponse: cell.twitchGame)
            }
        }
        
        disposeBag += streamsCollectionView.rx.modelSelected(GameResponse.self).subscribe(onNext: { [unowned self] game in
            self.favoriteGamesFeedViewModel?.gameTapped.onNext(game)
        })
    }
    
    private func configureStreamsCollectionView() {
        self.view.addSubview(streamsCollectionView)
        
        streamsCollectionView.showsVerticalScrollIndicator = false
        streamsCollectionView.showsHorizontalScrollIndicator = false
        
        streamsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        streamsCollectionView.register(GameCell.self, forCellWithReuseIdentifier: "cellId")
        
        let layout = streamsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 48, height: 180)
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        layout.scrollDirection = .vertical
    }
}
