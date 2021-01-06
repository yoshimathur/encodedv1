//
//  WelcomeViewController.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/18/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View has loaded :)")
        welcomeLabel.setTextWithTypeAnimation(typedText: "Welcome Agent! Encoded is an app designed for you to communicate with your comrades through the use of secret codes that you can create. In the app, you can create your codes, but the majority of the action takes place in iMessages. In iMessages, use the Encoded extension in order to encode your messages, decode your friends' messages and share the codes you have made. Now, off you go -- good luck agent!")
        welcomeLabel.font = UIFont(name: "Audiowide-Regular", size: 17)
        continueButton.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 20)
        // Do any additional setup after loading the view.
    }
    
    let defaults = UserDefaults(suiteName: "group.yashmathur.encoded")!
    
    //reference
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueToHome(_ sender: Any) {
        defaults.setValue(true, forKey: "User")
        defaults.setValue(5, forKey: "Limit")
        defaults.setValue([], forKey: "Codes")
        self.performSegue(withIdentifier: "welcomeToHomeSugue", sender: self)
    }

}

extension UILabel {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }

        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.1, execute: task)
        }
    }

}
