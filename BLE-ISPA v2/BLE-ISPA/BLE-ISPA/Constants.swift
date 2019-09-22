//
//  File.swift
//  BLE-ISPA
//
//  Created by Suresh on 9/22/19.
//  Copyright © 2019 Priya. All rights reserved.
//

import Foundation

import CoreBluetooth

struct Constants {
    static let SERVICE_UUID = CBUUID(string: "4DF91029-B356-463E-9F48-BAB077BF3EF5")
    static let RX_UUID = CBUUID(string: "3B66D024-2336-4F22-A980-8095F4898C42")
    static let RX_PROPERTIES: CBCharacteristicProperties = .write
    static let RX_PERMISSIONS: CBAttributePermissions = .writeable
    
}
