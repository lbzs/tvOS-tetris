//
//  GameOverScene.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 29..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameOverScene: SKScene {
    var score: Int!
    var lines: Int!
    var okButton: SKShapeNode!

    override func didMove(to view: SKView) {
        let scoreLabel = childNode(withName: "score") as? SKLabelNode
        scoreLabel?.text = String(score)
        let linesLabel = childNode(withName: "lines") as? SKLabelNode
        linesLabel?.text = String(lines)
        okButton = childNode(withName: "okButton") as? SKShapeNode
        okButton.isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if okButton.isFocused {
            if let scene = GKScene(fileNamed: "MenuScene"), let sceneNode = scene.rootNode as! MenuScene?, let view = self.view {
                view.presentScene(sceneNode)
            }
        }
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [okButton]
    }
}
