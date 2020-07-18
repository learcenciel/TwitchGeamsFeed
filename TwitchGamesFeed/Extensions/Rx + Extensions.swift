//
//  Rx + Extension.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 06.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RxSwift

func += (left: DisposeBag, right: Disposable) {
    right.disposed(by: left)
}

func += (left: DisposeBag, right: Disposable?) {
    right?.disposed(by: left)
}
