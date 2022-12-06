//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Рамина Ергалиева on 21.11.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation
import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = K.appName

//        titleLabel.text = ""
//        var charIndex = 0.0
//        let titleText = "⚡️FlashChat"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
//                self.titleLabel.text?.append(letter)
//            }
//        charIndex += 1
//
//        }  //how to make animation without cocoapod
    }
}


