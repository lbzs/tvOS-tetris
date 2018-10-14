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
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        scoreLabel.text = String(score)
        linesLabel.text = String(lines)
        
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber.init(value: UIPress.PressType.menu.rawValue)]
        view.addGestureRecognizer(menuPressRecognizer)
        backgroundImageView.image = #imageLiteral(resourceName: "background")
    }

    @objc func menuButtonAction() {
        dismiss(animated: true, completion: nil)
        presentingViewController?.dismiss(animated: false, completion: nil)
    }

    @IBAction func okButtonAction(_ sender: Any) {
        menuButtonAction()
    }
}
