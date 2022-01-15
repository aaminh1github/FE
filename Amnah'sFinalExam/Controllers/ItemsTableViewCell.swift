//
//  ItemsTableViewCell.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 11/06/1443 AH.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLable: UILabel!
    @IBOutlet weak var itemEmailLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
