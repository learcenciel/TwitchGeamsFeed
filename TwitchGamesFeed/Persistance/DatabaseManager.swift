//
//  DatabaseManager.swift
//  TwitchGamesFeed
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Team. All rights reserved.
//

import RealmSwift

class DatabaseManager {
    
    private let schemaVersion: UInt64 = 1
    
    // MARK: Configuration with migration support
    
    private lazy var realmConfiguration = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: runMigrations)
    private lazy var realm = try! Realm(configuration: realmConfiguration)
    
    // MARK: Migration block
    
    private func runMigrations(_ migration: Migration, oldSchemaVersion: UInt64) {
    }
    
    // MARK: Fetch, Delete, Add objects to Database
    
    func getGames() -> [RealmGame] {
        return Array(realm.objects(RealmGame.self))
    }
    
    func isFavorite(gameResponse: GameResponse) -> Bool {
        let query = NSPredicate(format: "id == %d", gameResponse.game.id)
        return realm.objects(RealmGame.self).filter(query).count > 0
    }
    
    func delete(gameResponse: GameResponse) {
        try! realm.write {
            realm.delete(realm.objects(RealmGame.self).filter("id=%@", gameResponse.game.id))
        }
        NotificationCenter.default.post(name: .didUpdateGame,
                                        object: nil,
                                        userInfo: createUserInfo(gameResponse, isFavorite: false))
    }
    
    func saveGame(_ gameResponse: GameResponse) {
        try! realm.write {
            let game = RealmGame(id: gameResponse.game.id,
                                       title: gameResponse.game.name,
                                       posterUrl: gameResponse.game.imageBox.gameUrlPath,
                                       viewersCount: gameResponse.viewersCount)
            realm.create(RealmGame.self, value: game, update: .all)
        }
        NotificationCenter.default.post(name: .didUpdateGame,
                                        object: nil,
                                        userInfo: createUserInfo(gameResponse, isFavorite: true))
    }
    
    private func createUserInfo(_ gameResponse: GameResponse,
                                isFavorite: Bool) -> [String: RealmGameNotification] {
        let realmGameNotification = RealmGameNotification(gameId: gameResponse.game.id,
                                                          isFavorite: isFavorite)
        let userInfo: [String: RealmGameNotification] = ["game": realmGameNotification]
        return userInfo
    }
}
