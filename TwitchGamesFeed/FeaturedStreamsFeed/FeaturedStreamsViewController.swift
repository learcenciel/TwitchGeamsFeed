//
//  FeaturedStreamsViewController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class FeaturedStreamsViewController: UIViewController {
    
    private lazy var featuredStreamsTableView: UITableView = {
        let featuredStreamsTableView = UITableView()
        featuredStreamsTableView.backgroundColor = .clear
        featuredStreamsTableView.separatorStyle = .none
        return featuredStreamsTableView
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
    
    // MARK: Views configure methods
    
    private func configureBindings() {
        disposeBag += featuredStreamsViewModel?
            .featuredStreams
            .observeOn(MainScheduler.instance)
            .bind(to: self.featuredStreams)
        
        disposeBag += featuredStreams.bind(to: featuredStreamsTableView.rx.items(cellIdentifier: "cellId", cellType: TwitchFeaturedStreamCell.self)) { row, featuredStream, cell in
            cell.featuredStream = featuredStream
        }
        
        disposeBag += featuredStreamsTableView.rx.modelSelected(FeaturedResponse.self)
            .subscribe(onNext: { [unowned self] stream in
                self.featuredStreamsViewModel?.featuredStreamTapped.onNext(stream)
            })
        
        disposeBag += featuredStreamsViewModel?.error.subscribe(onNext: { error in
            print(error)
        })
            
        disposeBag += featuredStreamsTableView.rx.contentOffset
            .skip(3)
            .subscribe(onNext: { [unowned self] offset in
                if self.featuredStreamsTableView.isNearBottomEdge(edgeOffset: 20) && !self.featuredStreamsViewModel!.isLoading {
                    self.featuredStreamsViewModel!.isLoading = true
                    self.featuredStreamsViewModel?.fetchNextGamesList()
                }
            })
    }
    
    func configureStreamsCollectionView() {
        self.view.addSubview(featuredStreamsTableView)
        
        featuredStreamsTableView.showsVerticalScrollIndicator = false
        featuredStreamsTableView.showsHorizontalScrollIndicator = false
        
        featuredStreamsTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        featuredStreamsTableView.register(TwitchFeaturedStreamCell.self, forCellReuseIdentifier: "cellId")
        featuredStreamsTableView.rowHeight = UITableView.automaticDimension
    }
}
