//
//  GameViewController.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 17..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import SpriteKit
import GameKit
import GameplayKit

enum DifficultyLevel: Int {
    case normal, hard
}

class GameViewController: UIViewController {

    var currentScene: GameScene?
    var difficulty: DifficultyLevel?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameOver),
                                               name: .presentGameOverViewController,
                                               object: nil)

        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as! GameScene? {

                sceneNode.scaleMode = .aspectFill

                if let view = self.view as! SKView? {
                    currentScene = sceneNode
                    if difficulty == .hard {
                        currentScene?.columns = 20
                    }

                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? GameOverViewController, let scene = currentScene else { return }
        
        destinationVC.score = scene.score
        destinationVC.lines = scene.lines

        if GameKitHelper.shared.enableGameCenter {
            let score = GKScore(leaderboardIdentifier: GameKitHelper.shared.leaderboardIdentifier)
            score.value = Int64(scene.score)
            GKScore.report([score]) { (error) in
                if error != nil {
                    GameKitHelper.shared.error = error
                }
            }
        }
    }

    @objc func gameOver() {
        performSegue(withIdentifier: "gameOverSegue", sender: self)
    }
}
