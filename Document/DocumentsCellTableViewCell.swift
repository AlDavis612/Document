//
//  DocumentsCellTableViewCell.swift
//  Document
//
//  Created by Alex Davis on 8/29/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//

import UIKit

class DocumentsCellTableViewCell: UITableViewCell {
   
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var SizeLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
