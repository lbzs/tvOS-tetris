//
//  GameScene.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameField: SKTileMapNode!

    override func didMove(to view: SKView) {
        guard let gameField = childNode(withName: "gameField") as? SKTileMapNode else {
            fatalError("Background node not loaded")
        }

        self.gameField = gameField

        guard let tileSet = SKTileSet(named: "Tile Sets") else {
            fatalError("Tile Sets not found")
        }

        let tileGroups = tileSet.tileGroups

        guard let field = tileGroups.first(where: {$0.name == "Field"}) else {
            fatalError("No Field tile definition found")
        }

        gameField.setTileGroup(field, forColumn: 10, row: 10)
    }
}
