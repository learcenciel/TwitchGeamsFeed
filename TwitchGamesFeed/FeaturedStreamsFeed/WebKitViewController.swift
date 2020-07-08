//
//  WebKitViewController.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 07.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit
import WebKit

class WebKitViewController: UIViewController {

    private var webView: WKWebView!
    var streamUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 22/255, green: 22/255, blue: 25/255, alpha: 1.0)
        configureWebView()
    }
    
    private func configureWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        self.title = "Stream"
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    private func loadUrl() {
        guard
            let url = URL(string: "https://www.twitch.tv/\(streamUrl)")
        else { return }
        
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        loadUrl()
    }
}

extension WebKitViewController: WKNavigationDelegate {
}
