//
//  GameKitHelper.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 09. 30..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import GameKit
import UIKit

class GameKitHelper {

    var enableGameCenter = false
    var leaderboardIdentifier = String()
    var authenticationVC: UIViewController? {
        didSet(newAuthenticationVC) {
            NotificationCenter.default.post(name: .presentAuthenticationViewController, object: self)
        }
    }

    var error: Error? {
        didSet(newError) {
            print("GameKitHelper ERROR: \(error!.localizedDescription)")
        }
    }

    private init() {}
    static let shared = GameKitHelper()

    func autehenticateLocalUser() {
        let player = GKLocalPlayer.local

        player.authenticateHandler = { [weak self](viewController, error) -> Void in
            if error != nil {
                self?.error = error!
            }

            if viewController != nil {
                self?.authenticationVC = viewController
    
            } else if player.isAuthenticated {
                self?.enableGameCenter = true

                player.loadDefaultLeaderboardIdentifier(completionHandler: { (identifier, error) in
                    if error != nil {
                        self?.error = error
                    } else if identifier != nil {
                        self?.leaderboardIdentifier = identifier!
                    }
                })
            } else {
                self?.enableGameCenter = false
            }
        }
    }
}

extension Notification.Name {
    static let presentAuthenticationViewController = NSNotification.Name("presentAuthenticationViewController")
}

