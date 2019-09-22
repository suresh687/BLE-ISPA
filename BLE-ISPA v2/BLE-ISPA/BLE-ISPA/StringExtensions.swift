//
//  StringExtensions.swift
//  BLE-ISPA
//
//  Created by Suresh on 9/22/19.
//  Copyright © 2019 Priya. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
