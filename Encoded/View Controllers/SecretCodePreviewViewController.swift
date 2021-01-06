//
//  SecretCodePreviewViewController.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/19/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecretCodePreviewViewController: UIViewController, GADBannerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
    }
    
    let defaults = UserDefaults(suiteName: "group.yashmathur.encoded")!
    
    //code information
    var codeName: String? = ""
    var codeDescription: String? = ""
    var codeID: String? = ""
    
    var code: [String : String] = [ : ]
    
    //references
    @IBOutlet weak var codeNameLabel: UILabel!
    @IBOutlet weak var codeIDLabel: UITextView!
    @IBOutlet weak var codeDataLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var encodeButtonRef: UIButton!
    @IBOutlet weak var decodeButtonRef: UIButton!
    
    func setUpElements() {
        
        //fonts and display
        codeNameLabel.font = UIFont(name: "Audiowide-Regular", size: 20)
        codeIDLabel.font = UIFont(name: "Audiowide-Regular", size: 15)
        codeIDLabel.isUserInteractionEnabled = true
        codeDataLabel.font = UIFont(name: "Audiowide-Regular", size: 12)
        encodeButtonRef.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 15)
        decodeButtonRef.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 15)
        
        //setting up the labels to disply the name and description
        self.codeNameLabel.text = self.codeName ?? "Coudn't Retrieve Data!"
        self.codeIDLabel.text = "codeID: \(self.codeID ?? "Couldn't Retrieve Data!")"
        
        //setting up the code data
        if codeID?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let code = defaults.array(forKey: codeID!)
            let values: [String] = code![2] as! [String]
            self.code = ["a" : values[0], "b" : values[1], "c" : values[2], "d" : values[3], "e" : values[4], "f" : values[5], "g" : values[6], "h" : values[7], "i" : values[8], "j" : values[9], "k" : values[10], "l" : values[11], "m" : values[12], "n" : values[13], "o" : values[14], "p" : values[15], "q" : values[16], "r" : values[17], "s" : values[18], "t" : values[19], "u" : values[20], "v" : values[21], "w" : values[22], "x" : values[23], "y" : values[24], "z" : values[25], " " : " ", "\n" : "\n"]
            self.codeDataLabel.text = "Code: \(self.code.description)"
        } else {
            self.code = [ : ]
            self.codeDataLabel.text = "No code found!"
        }
    }
    
    //encoding
    @IBAction func encode(_ sender: Any) {
        var output: String = ""
        let input: String = inputTextView.text
        for character in input {
            let key: String = character.description.lowercased()
            let value: String? = code[key]
            output.append(contentsOf: value ?? key)
        }
        outputTextView.text = output
    }
    
    
    //decoding
    @IBAction func decode(_ sender: Any) {
        let decodeDict = Dictionary(uniqueKeysWithValues: self.code.map({ ($1, $0) }))
        var output: String = ""
        let input: String = inputTextView.text
        for character in input {
            let key: String = character.description
            let value: String? = decodeDict[key]
            output.append(contentsOf: value ?? key)
        }
        outputTextView.text = output
    }
    
    
}
