//
//  TrainerClassReservationTableViewCell.swift
//  MyGYM
//
//  Created by Deema on 09/03/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class TrainerClassReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var memberID: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
