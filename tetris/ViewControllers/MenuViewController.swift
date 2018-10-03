//
//  MenuViewController.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 10. 02..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import UIKit
import GameKit

class MenuViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoresButton: UIButton!

    @IBAction func showScores(_ sender: Any) {
        if GameKitHelper.shared.enableGameCenter {
            let gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            present(gcVC, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showAuthenticationViewController),
                                               name: .presentAuthenticationViewController ,
                                               object: nil)
        GameKitHelper.shared.autehenticateLocalUser()
    }

    @objc func showAuthenticationViewController() {
        present(GameKitHelper.shared.authenticationVC!,
                animated: true,
                completion: nil)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    @IBAction func unwindToDetailsViewController(segue: UIStoryboardSegue) {}
}
