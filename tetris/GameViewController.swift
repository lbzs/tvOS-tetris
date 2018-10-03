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

class GameViewController: UIViewController {

    var currentScene: GameScene?
    var player: GKLocalPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(gameOver),
                                               name: .presentGameOverViewController,
                                               object: nil)

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    currentScene = sceneNode
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
