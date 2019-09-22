//
//  BLETableViewCell.swift
//  BLE-ISPA
//
//  Created by Suresh on 9/21/19.
//  Copyright © 2019 Priya. All rights reserved.
//

import UIKit

class BLETableViewCell: UITableViewCell {
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var UUID: UILabel!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
