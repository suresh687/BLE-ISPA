//
//  Message.swift
//  BLE-ISPA
//
//  Created by Suresh on 9/22/19.
//  Copyright © 2019 Priya. All rights reserved.
//

import Foundation
struct Message {
    
    var text : String
    var isSent : Bool
    
    init(text: String, isSent: Bool) {
        
        self.text = text
        self.isSent = isSent
    }
}
