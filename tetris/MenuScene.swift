//
//  MenuScene.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    var newGameButton: SKShapeNode?
    var scoresButton: SKShapeNode?
    
    override func didMove(to view: SKView) {
        newGameButton = childNode(withName: "newGameButton") as? SKShapeNode
        newGameButton?.isUserInteractionEnabled = true
        scoresButton = childNode(withName: "scoresButton") as? SKShapeNode
        scoresButton?.isUserInteractionEnabled = true
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let didLostFocusButton = context.previouslyFocusedItem
        let didGetFocusButton = context.nextFocusedItem
        
        if let button = didLostFocusButton as? SKShapeNode {
            button.shapeDidLoseFocus()
        }

        if let button = didGetFocusButton as? SKShapeNode {
            button.shapeDidGetFocus()
        }
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        guard let firstButton = newGameButton, let secondButton = scoresButton else { return [] }
        return [firstButton, secondButton]
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if newGameButton?.contains(location) == true {
                
            } else if scoresButton?.contains(location) == true {
                
            }
        }
    }
}

extension SKShapeNode {
    func shapeDidLoseFocus() {
        fillColor = SKColor.white
    }

    func shapeDidGetFocus() {
        fillColor = SKColor.gray
    }

    override open var canBecomeFocused: Bool {
        get {
            return true
        }
    }
}
