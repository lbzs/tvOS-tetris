//
//  MenuScene.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    var newGameButton: SKShapeNode!
    var scoresButton: SKShapeNode!

    override func didMove(to view: SKView) {
        newGameButton = childNode(withName: "newGameButton") as? SKShapeNode
        newGameButton.isUserInteractionEnabled = true
        scoresButton = childNode(withName: "scoresButton") as? SKShapeNode
        scoresButton.isUserInteractionEnabled = true
        
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [newGameButton, scoresButton]
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if newGameButton.isFocused == true {
            if let scene = GKScene(fileNamed: "GameScene"), let sceneNode = scene.rootNode as! GameScene?, let view = self.view {
                view.presentScene(sceneNode)
            }
        } else if scoresButton.isFocused == true {
            if let scene = GKScene(fileNamed: "ScoreScene"), let sceneNode = scene.rootNode as! ScoreScene?, let view = self.view {
                view.presentScene(sceneNode)
            }
        }
    }
}

extension SKScene {
    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let didLostFocusButton = context.previouslyFocusedItem
        let didGetFocusButton = context.nextFocusedItem
        
        if let button = didLostFocusButton as? SKShapeNode {
            button.shapeDidLoseFocus()
        }
        
        if let button = didGetFocusButton as? SKShapeNode {
            button.shapeDidGetFocus()
        }
    }
}

extension SKShapeNode {
    
    func shapeDidLoseFocus() {
        fillColor = SKColor.gray
    }

    func shapeDidGetFocus() {
        fillColor = SKColor.white
    }

    override open var canBecomeFocused: Bool {
        get {
            return true
        }
    }
}
