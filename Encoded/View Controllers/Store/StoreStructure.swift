//
//  StoreStructure.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/21/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import Foundation
import UIKit

struct Store {
    
    static let storeItems: [String] = ["1+ Code", "3+ Codes", "System Keyboards"]
    
    static let storeItemDescriptions: [String] = ["Create one more code to share with your friends!  $0.99", "Get access to create 3 more codes that you can share with your friends!  $1.99", "Unlock the emoji keyboard and all system keyboards to use emojis and different langues in your code!  $4.99"]
    
    static let IAPRefs: [String] = ["com.yashmathur.encoded.add_one_code", "com.yashmathur.encoded.add_three_codes", "com.yashmathur.encoded.unlock_system_keyboards"]
    
    static let storeImages: [UIImage?] = [UIImage.init(named: "add1"), UIImage.init(named: "add3"),UIImage.init(named: "shhh emoji")]
    
    //shapes keyboard
    //"Shapes Keyboard"
    //"Unlock the special Encoded Shape Keyboard to use custom shape characters in your code!  $1.99"
}
