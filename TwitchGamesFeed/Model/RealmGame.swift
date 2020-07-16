//
//  RealmTwitchGame.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import Foundation
import RealmSwift

class RealmGame: Object {
    
    @objc dynamic var id: Int
    @objc dynamic var title: String
    @objc dynamic var posterUrl: String
    @objc dynamic var viewersCount: Int
    
    init(id: Int,
         title: String,
         posterUrl: String,
         viewersCount: Int) {
        self.id = id
        self.title = title
        self.posterUrl = posterUrl
        self.viewersCount = viewersCount
    }
    
    required init() {
        self.id = 0
        self.title = ""
        self.posterUrl = ""
        self.viewersCount = 0
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func getGameResponse(_ realmTwitchGames: [RealmGame]) -> [GameResponse] {
        
        var twitchGameResponse: [GameResponse] = []
        
        for realmTwitchGame in realmTwitchGames {
            
            let imageBox = ImageBox(gameUrlPath: realmTwitchGame.posterUrl)
            let game = Game(name: realmTwitchGame.title,
                                  id: realmTwitchGame.id,
                                  imageBox: imageBox)
            
            twitchGameResponse.append(GameResponse(game: game,
                                                         viewersCount: realmTwitchGame.viewersCount))
        }
        
        return twitchGameResponse
    }
    
    static func getRealmGame(_ gameResponse: GameResponse) -> RealmGame {
        return RealmGame(id: gameResponse.game.id,
                               title: gameResponse.game.name,
                               posterUrl: gameResponse.game.imageBox.gameUrlPath,
                               viewersCount: gameResponse.viewersCount)
    }
}
