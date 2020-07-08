//
//  FeaturedStreamsViewController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

class FeaturedStreamsViewController: UIViewController {

    private lazy var featuredStreamsCollectionView: UICollectionView = {
        let streamsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        streamsCollectionView.backgroundColor = .clear
        return streamsCollectionView
    }()
    
    var featuredStreamsViewModel: FeaturedStreamsViewModel?
    private let featuredStreams: BehaviorRelay<[FeaturedResponse]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStreamsCollectionView()
        configureBindings()
        featuredStreamsViewModel?.fetchFeaturedStreamsList()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.tintColor = .black
        self.title = "Featured"
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        print("DEINIT VC")
    }
    
    // MARK: Views configure methods
    
    private func configureBindings() {
        disposeBag += featuredStreamsViewModel?
            .featuredStreams
            .observeOn(MainScheduler.instance)
            .bind(to: self.featuredStreams)
        
        disposeBag += featuredStreams.bind(to: featuredStreamsCollectionView.rx.items(cellIdentifier: "cellId", cellType: TwitchFeaturedStreamCell.self)) { row, featuredStream, cell in
            cell.featuredStream = featuredStream
        }
        
        disposeBag += featuredStreamsCollectionView.rx.modelSelected(FeaturedResponse.self)
            .share(replay: 1, scope: .whileConnected)
            .subscribe(onNext: { [weak self] stream in
            self?.featuredStreamsViewModel?.featuredStreamTapped.onNext(stream)
        })
        
        disposeBag += featuredStreamsViewModel?.error.subscribe(onNext: { error in
            print(error)
        })
        
        disposeBag += featuredStreamsCollectionView.rx.contentOffset
            .skip(1)
            .subscribe(onNext: { [unowned self] offset in
                if self.featuredStreamsCollectionView.isNearBottomEdge(edgeOffset: 20) && !self.featuredStreamsViewModel!.isLoading {
                    self.featuredStreamsViewModel!.isLoading = true
                    self.featuredStreamsViewModel?.fetchNextGamesList()
                }
            })
    }
    
    func configureStreamsCollectionView() {
        self.view.addSubview(featuredStreamsCollectionView)
        
        featuredStreamsCollectionView.showsVerticalScrollIndicator = false
        featuredStreamsCollectionView.showsHorizontalScrollIndicator = false
        
        featuredStreamsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        featuredStreamsCollectionView.register(TwitchFeaturedStreamCell.self, forCellWithReuseIdentifier: "cellId")
        
        let layout = featuredStreamsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: view.frame.width - 48, height: view.frame.height * 0.3)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
    }
}
