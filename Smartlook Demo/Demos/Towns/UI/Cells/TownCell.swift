//
//  TownCell.swift
//  Smartlook Demo
//
//  Copyright © 2020 Smartlook. All rights reserved.
//

import UIKit

class TownCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet var flag: UIImageView!
    @IBOutlet var name: UILabel!


    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        flag.layer.borderWidth = 1
        flag.layer.borderColor = UIColor.systemGray4.cgColor
    }
}
