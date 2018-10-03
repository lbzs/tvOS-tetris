//
//  GameOverViewController.swift
//  tetris
//
//  Created by Balint Zsombor Lakatos on 2018. 10. 02..
//  Copyright © 2018. Balint Zsombor Lakatos. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    var score = 0
    var lines = 0
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var linesLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        scoreLabel.text = String(score)
        linesLabel.text = String(lines)
    }
}
