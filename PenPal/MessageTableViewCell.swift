//
//  MessageTableViewCell.swift
//  PenPal
//
//  Created by Karina Ionkina on 5/12/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var uid: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name:String, uid: String){
        self.nameLabel.text = name
        self.uid = uid
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
