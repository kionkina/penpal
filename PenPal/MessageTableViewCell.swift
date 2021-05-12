//
//  MessageTableViewCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name:String){
        self.nameLabel.text = name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
