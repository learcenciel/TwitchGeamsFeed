//
//  TwitchSearchFeedViewController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 12.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class SearchFeedViewController: UIViewController {

    enum SearchType: String, CaseIterable {
        case streams = "Streams"
        case channels = "Channels"
    }
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var searchTextField: SearchTextFieldView = {
        let textField = SearchTextFieldView()
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.textColor = .black
        textField.tintColor = .black
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        textField.delegate = self
        return textField
    }()
    
    private let searchTypeSegmentedControl = SearchTypeSegmentedControl(frame: .zero, buttonTitles: [])
    
    private lazy var searchItemsTableView: UITableView = {
        let searchItemsTableView =
            UITableView(frame: .zero)
        searchItemsTableView.showsVerticalScrollIndicator = false
        searchItemsTableView.register(StreamCell.self, forCellReuseIdentifier: "cellId1")
        searchItemsTableView.register(SearchChannelCell.self, forCellReuseIdentifier: "cellId2")
        searchItemsTableView.delegate = self.currentSearchController
        searchItemsTableView.dataSource = self.currentSearchController
        searchItemsTableView.backgroundColor = .white
        searchItemsTableView.separatorStyle = .none
        return searchItemsTableView
    }()
    
    var searchControllers = [SearchCapable]()
    var currentSearchController: SearchCapable!
    
    var searchFeedViewModel: SearchFeedViewModel!
    private let disposeBag = DisposeBag()
    
    private var query = ""
    private var offset = 0
    
    // MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        configureViews()
        configureSearchTypeSegmentedControl()
        configureSearchItemsTableView()
        self.title = SearchType.allCases[0].rawValue
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
    
    // MARK: Configure View
    private func configureBindings() {
        disposeBag += searchTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ textInput in
                textInput != ""
            })
            .subscribe(onNext: { [unowned self] textInpiut in
                self.query = textInpiut
                self.currentSearchController.search(query: self.query, offset: 0)
            })
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(searchContainerView)
        self.searchContainerView.addSubview(searchTextField)
        searchContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
        }
        searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14))
        }
    }
    
    private func configureSearchTypeSegmentedControl() {
        self.view.addSubview(searchTypeSegmentedControl)
        self.searchTypeSegmentedControl.delegate = self
        var buttonTitles = [String]()
        SearchType.allCases.forEach { searchType in
            buttonTitles.append(searchType.rawValue)
        }
        self.searchTypeSegmentedControl.setButtonTitles(buttonTitles: buttonTitles)
        self.searchTypeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureSearchItemsTableView() {
        self.view.addSubview(searchItemsTableView)
        searchItemsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTypeSegmentedControl.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        searchItemsTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func changeDelegateAndDataSource() {
        self.searchItemsTableView.delegate = self.currentSearchController
        self.searchItemsTableView.dataSource = self.currentSearchController
    }
}

// MARK: UITextFieldDelegate

extension SearchFeedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: Motion and Touch override

extension SearchFeedViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: StreamSearchControllerDelegate

extension SearchFeedViewController: StreamSearchControllerDelegate {
    func didRetreiveStreams() {
        changeDelegateAndDataSource()
        self.searchItemsTableView.reloadData()
    }
    
    func didSelectStream(twitchStream: Stream) {
        print(twitchStream.title)
    }
}

// MARK: ChannelSearchControllerDelegate

extension SearchFeedViewController: ChannelSearchControllerDelegate {
    func didRetreiveChannels() {
        changeDelegateAndDataSource()
        self.searchItemsTableView.reloadData()
    }
    
    func didSelectChannel(channel: SearchChannel) {
        print(channel.url)
    }
}

// MARK: SearchTypeSegmentedControlDelegate

extension SearchFeedViewController: SearchTypeSegmentedControlDelegate {
    func didSelect(item at: Int) {
        self.currentSearchController = self.searchControllers[at]
        
        changeDelegateAndDataSource()
        self.currentSearchController.search(query: self.query, offset: 0)
        self.searchItemsTableView.reloadData()
        
        self.title = SearchType.allCases[at].rawValue
    }
}
