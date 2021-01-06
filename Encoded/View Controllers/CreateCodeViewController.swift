//
//  CreateCodeViewController.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/18/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit

class CreateCodeViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        systemKeyboards()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        print("View has loaded :)")
    }
    
    let defaults = UserDefaults(suiteName: "group.yashmathur.encoded")!
    
    //references
    @IBOutlet weak var codeName: UITextField!
    @IBOutlet weak var codeDescription: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var createCodeButtonRef: UIButton!
    
    //character references
    @IBOutlet var characters: [UITextField]!
    
    //function to set up elements
    func setUpElements() {
        
        //fonts and display
        codeName.font = UIFont(name: "Audiowide-Regular", size: 17)
        codeDescription.font = UIFont(name: "Audiowide-Regular", size: 14)
        instructionLabel.font = UIFont(name: "Audiowide-Regular", size: 14)
        for character in characters {
            character.delegate = self
            character.font = UIFont(name: "Audiowide-Regular", size: 14)
        }
        
        //error labels
        errorLabel.font = UIFont(name: "Audiowide-Regular", size: 12)
        errorLabel.alpha = 0
        
        //buttons
        createCodeButtonRef.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 15)
    }
    
    //function to transition back to code home
    func transitionToHome() {
        let newVC = self.storyboard?.instantiateViewController(identifier: "CodesVC") as? SecretCodesHomeViewController
        self.view.window?.rootViewController = newVC
        view.window?.makeKeyAndVisible()
    }
    
    //restricted characters
    let restrictedCharacters = [".", "!", ",", "?", "'", "", "-", ":", ";", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    func restrictedContent() -> Bool {
        print("Checking for restricted characters!")
        for character in characters{
            for i in 0..<restrictedCharacters.count {
                if character.text!.trimmingCharacters(in: .whitespacesAndNewlines) == restrictedCharacters[i] {
                    character.backgroundColor = UIColor.systemPink
                    print("Code has a restricted value!")
                    return true
                } else {
                    continue
                }
            }
        }
        return false
    }
    
    func emptyContent() -> Bool {
        print("Checking for empty spaces!")
        for character in characters{
            if character.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                character.backgroundColor = UIColor.systemPink
                print("Code has an empty space!")
                return true
            } else {
                continue
            }
        }
        return false
    }
    
    //create code button
    @IBAction func createCode(_ sender: Any) {
        
        //resetting colors
        for character in characters {
            character.backgroundColor = UIColor.init(named: "Classic Font")
        }
        
        //handling error
        if self.codeName.text == "" {
            self.errorLabel.text = "Please give your code a name."
            self.errorLabel.alpha = 1
        } else if self.codeDescription.text == "" {
            self.errorLabel.text = "Please give your code a short description."
            self.errorLabel.alpha = 1
        } else if emptyContent() {
            self.errorLabel.text = "Please assign a character to each letter."
            self.errorLabel.alpha = 1
        } else if restrictedContent() {
            self.errorLabel.text = "Certain punctuation and numbers are restricted due to schematics! Please fix your code."
            self.errorLabel.alpha = 1
        } else {
            //data to be stored
            let codeName: String = self.codeName.text!
            let codeDesciption: String = self.codeDescription.text!
            
            //array with assigned values
            var encodedValues: [String] = []
            for character in characters {
                encodedValues.append(character.text!)
            }
            let cleanedValues: [String] = encodedValues.removingDuplicates()
            
            if cleanedValues.count != encodedValues.count {
                for i in 0..<encodedValues.count {
                    for j in 0..<encodedValues.count {
                        if i == j {
                            continue
                        }
                        if encodedValues[i] == encodedValues[j] {
                            characters[i].backgroundColor = UIColor.systemPink
                            characters[j].backgroundColor = UIColor.systemPink
                            break
                        }
                    }
                }
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please make sure that no two letters share one or more unique characters."
            } else {
                self.errorLabel.alpha = 0
                //storing the data
                let codeID: String = randomString(length: 7)
                var codes: [String] = defaults.array(forKey: "Codes") as! [String]
                codes.append(codeID)
                defaults.setValue(codes, forKey: "Codes")
                print(defaults.array(forKey: "Codes") as Any)
                let data = [codeName, codeDesciption, encodedValues] as [Any]
                defaults.setValue(data, forKey: codeID)
                transitionToHome()
            }
        }
    }
    
    //ensuring all the textfields have only one character
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {return false}
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
    
    //making keyboard go away on done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.hasText {
            let textFieldIndex: Int? = characters.firstIndex(of: textField)
            if let index = textFieldIndex {
                let nextChar = index + 1
                if nextChar >= characters.count {
                    textField.resignFirstResponder()
                    return true
                } else {
                    self.characters[nextChar].becomeFirstResponder()
                    return true
                }
            } else {
                print("Fatal Error")
                return false
            }
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    //function to allow system keyboards in code
    func systemKeyboards() {
        if defaults.bool(forKey: "System Keyboards") {
            for character in characters {
                character.keyboardType = .default
            }
        } else {
            for character in characters {
                character.keyboardType = .asciiCapable
            }
        }
    }
    
    //generate random string UUID
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

}



//array extension to remove duplicates
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
